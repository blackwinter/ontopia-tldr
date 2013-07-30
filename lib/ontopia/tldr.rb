# encoding: utf-8

#--
###############################################################################
#                                                                             #
# ontopia-tldr -- Tolog Document Retrieval with Ontopia.                      #
#                                                                             #
# Copyright (C) 2013 Jens Wille                                               #
#                                                                             #
# ontopia-tldr is free software: you can redistribute it and/or modify it     #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation, either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# ontopia-tldr is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with ontopia-tldr. If not, see <http://www.gnu.org/licenses/>.        #
#                                                                             #
###############################################################################
#++

require 'json'
require 'sinatra/base'
require 'nuggets/midos'
require 'ontopia/topicmaps'

module Ontopia
  class TLDR < Sinatra::Base

    class << self

      private

      def jget(*a, &b)
        jroute(:get, *a, &b)
      end

      def jpost(*a, &b)
        jroute(:post, *a, &b)
      end

      def jroute(m, r, t, &b)
        e = 'json'; e.prepend('.') unless r.end_with?('/')
        send(m, "#{r}#{e}")         { instance_eval(&b); do_json }
        send(m, r, provides: :html) { instance_eval(&b); erb(t) }
        send(m, r, provides: :json) { instance_eval(&b); do_json }
      end

    end

    set :root, __FILE__.chomp('.rb')

    set :otm do
      @__otm__ ||= Ontopia::Topicmaps::Topicmap.new(settings.xtm_file).tap {
        Ontopia::Topicmaps.default_stringifier = :id
      }
    end

    set :dbm do
      @__dbm__ ||= begin
        dbm, topic_keys = {}, settings.topic_keys

        topic_index = Hash.new { |h, k| h[k] = {} }
        dbm.define_singleton_method(:topic_index) { topic_index }

        Nuggets::Midos::Parser.parse_file(settings.dbm_file, settings.dbm_opts) { |id, doc|
          unless (topics = doc.values_at(*topic_keys).compact).empty?
            dbm[id] = doc
            topics.flatten.each { |topic| topic_index[topic][id] = doc }
          end
        }

        dbm
      end
    end

    set :topics do
      @__topics__ ||= settings.otm.topics(:name)
    end

    set :topic_index do
      @__topic_index__ ||= settings.dbm.topic_index
    end

    set :document_keys, %w[]
    set :topic_keys,    %w[]

    set :title, 'TLDR'

    set :xtm_file, File.expand_path('../tldr.xtm', __FILE__)
    set :dbm_file, File.expand_path('../tldr.dbm', __FILE__)
    set :dbm_opts, { encoding: 'utf-8', vs: '|' }

    set :tolog, <<-EOT
import "http://psi.ontopia.net/tolog/string/" as s
%s
select %s from %s?
    EOT

    set :title_topic, 'TOPIC'
    set :title_query, 'YOUR QUERY'
    set :title_rules, 'CUSTOM INFERENCE RULES (optional)'

    set :tolog_sample, {
      q: <<-EOT,
Production($_ : isProducing, $TOPIC : isProductOf),
topic-name($TOPIC, $PRODUCTNAME),
value($PRODUCTNAME, $PRODUCTSTRING),
s:contains($PRODUCTSTRING, "service")
      EOT
      r: <<-EOT
direct-narrower-term($A, $B) :-
  HierarchicalRelation($A : broaderTermMember,
                       $B : narrowerTermMember).

strictly-narrower-term($A, $B) :- {
  direct-narrower-term($A, $B) |
  direct-narrower-term($A, $C), strictly-narrower-term($C, $B)
}.

narrower-term($A, $B) :- {
  $A = $B | strictly-narrower-term($A, $B)
}.

narrower-term-1($A, $B) :- {
  $A = $B | direct-narrower-term($A, $B)
}.

narrower-term-2($A, $B) :- {
  narrower-term-1($A, $B) |
  narrower-term-1($A, $C), narrower-term-1($C, $B)
}.

narrower-term-3($A, $B) :- {
  narrower-term-2($A, $B) |
  narrower-term-2($A, $C), narrower-term-1($C, $B)
}.

direct-broader-term($A, $B) :-
  direct-narrower-term($B, $A).

strictly-broader-term($A, $B) :-
  strictly-narrower-term($B, $A).

broader-term($A, $B) :-
  narrower-term($B, $A).

broader-term-1($A, $B) :-
  narrower-term-1($B, $A).

broader-term-2($A, $B) :-
  narrower-term-2($B, $A).

broader-term-3($A, $B) :-
  narrower-term-3($B, $A).
      EOT
    }

    tolog_maps_base = <<-EOT
association-role($ASSOC, $ROLE),
association-role($ASSOC, $ROLE2),
role-player($ROLE, $TOPIC2),
role-player($ROLE2, $TOPIC),
type($ASSOC, $TYPE),
$TOPIC /= $TOPIC2
    EOT

    set :tolog_maps, {
      relations: <<-EOT,
select $TYPE, $ROLE, $TOPIC from
#{tolog_maps_base}, $TOPIC2 = %s?
      EOT
      roles: <<-EOT,
select $ROLE, $TOPIC from
#{tolog_maps_base}, type($ASSOC, %s)?
      EOT
      types: <<-EOT
select $TYPE, $TOPIC from
#{tolog_maps_base}, type($ROLE, %s)?
      EOT
    }

    helpers ERB::Util

    not_found do
      @error = 'Not found!'
      erb ''
    end

    get '/' do
      erb :index
    end

    jpost '/', :index do
      @query = params[:q]
      @rules = params[:r] || ''
      @param = params[:p] || TITLE_TOPIC

      if !@query || @query.strip.empty?
        @error = 'Query missing!'
      elsif !@param || @param.strip.empty? || @param =~ /\W/
        @error = 'Invalid projection!'
      elsif (@topics = get_topics).empty?
        @topics = nil
      elsif (@documents = get_documents).empty?
        @documents = nil
      else
        @filter = :documents
      end
    end

    get '/xtm' do
      do_file(settings.xtm_file, 'xml')
    end

    jget '/topics', :topics do
      @title = "Topics (#{settings.topics.size})"
      @topics, @filter = settings.topics.keys, :topics
    end

    jget '/topic/:i', :topic do
      @title = topic_to_s(@topic = params[:i])
      not_found unless settings.topics.include?(@topic)

      @documents, @filter = settings.topic_index[@topic], :documents
      @relations, @roles, @types = {}, {}, {}

      get_topic_maps(:relations)
      get_topic_maps(:roles) if @relations.empty?
      get_topic_maps(:types) if @roles.empty?
    end

    get '/dbm' do
      do_file(settings.dbm_file, 'txt')
    end

    jget '/documents', :documents do
      @title = "Documents (#{settings.dbm.size})"
      @documents, @filter = settings.dbm, :documents
    end

    jget '/document/:i', :document do
      @title = "##{@id = params[:i].to_i}"
      not_found unless @document = settings.dbm[@id]
    end

    private

    def do_json
      content_type :json

      JSON.fast_generate({
        d: @document || @documents,
        e: @error,
        i: @id,
        l: @relations,
        o: @roles,
        p: @param,
        q: @query,
        r: @rules,
        t: @topic || @topics,
        y: @types
      }.delete_if { |_, v| !v })
    end

    def do_file(file, type)
      File.readable?(file) ? send_file(file, type: type) : not_found
    end

    def get_topics(query = @query, param = @param, rules = @rules)
      settings.otm.query(settings.tolog % [rules, "$#{param}", query])
    rescue => err
      @error = err.to_s
      []
    end

    def get_topic_maps(name, topic = @topic, hash = nil, str = nil)
      hash ||= instance_variable_get("@#{name}")
      str  ||= Ontopia::Topicmaps.id_stringifier

      query = settings.tolog_maps[name] % topic
      keys  = settings.otm.extract_query_projection(query)

      settings.otm.query_maps(query).each { |map|
        values = map.values_at(*keys).map!(&str)
        topic, key = values.pop, values.pop

        (values.inject(hash) { |h, k| h[k] ||= {} }[key] ||= []) << topic
      }
    rescue => err
      @error = err.to_s
    end

    def get_documents(topics = @topics)
      settings.topic_index.values_at(*topics).compact.inject(&:merge)
    end

    def render_topics(topics = @topics)
      _ul(topics.sort, id: :topics) { |topic|
        _li(link_to_topic(topic), ' (', settings.topic_index[topic].size, ')')
      }
    end

    def render_documents(documents = @documents)
      _ul(documents.sort_by { |k,| k }, id: :documents) { |id, doc|
        _li(link_to_document(id, doc))
      }
    end

    def render_topics_hash(hash)
      _ul(hash.map { |k, v| [topic_to_s(k), k, v] }.sort) { |name, key, value|
        _li(link_to_topic(key, name),
          value.is_a?(Hash) ? render_topics_hash(value) :
            _ul(value.sort.uniq) { |topic| _li(link_to_topic(topic)) })
      }
    end

    def topic_to_s(topic)
      h(settings.topics[topic] || topic.tr('_', ' '))
    end

    def doc_to_s(id, doc)
      a, t, u, y = doc.values_at(*settings.document_keys)

      a = a.join('; ') if a.is_a?(Array)
      s = [a, t].compact.join(': ')

      if s.empty?
        s = "##{id}"
      elsif u
        s << " – #{u}"
      end

      s << " (#{y})" if y

      h(s)
    end

    def link_to_topic(topic, text = topic_to_s(topic))
      _a(text, href: url("/topic/#{h(topic)}"))
    end

    def link_to_document(id, doc)
      _a(doc_to_s(id, doc), href: url("/document/#{h(id)}"))
    end

    def _a(*args)
      _tag(:a, *args)
    end

    def _ul(list, *args)
      _tag(:ul, *args) { |t| list.each { |*i| t << yield(*i) } }
    end

    def _li(*args)
      _tag(:li, *args)
    end

    def _tag(name, *args)
      a = args.pop.map { |k, v| %Q{#{h(k)}="#{h(v)}"} } if args.last.is_a?(Hash)

      t = ["<#{name}#{a.unshift(nil).join(' ') if a}>"]

      args.each { |s| t << s }
      yield t if block_given?

      t << "</#{name}>"
      t.join
    end

  end
end

require_relative 'tldr/version'
