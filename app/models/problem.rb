require 'redcarpet'
class Problem < ActiveRecord::Base
  belongs_to :user
  has_many :submissions

  validates_presence_of :title, :body

  serialize :test_examples, Array

  paginates_per 20

  def rendered_body
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            no_intra_emphasis: true,
                            tables: true,
                            fenced_code_blocks: true,
                            autolink: true,
                            lax_spacing: true) \
                       .render(self.body) \
                       .html_safe
  end

  def test_examples
    (self.attributes["test_examples"] || []).map.with_index do |e, i|
      TestExample.new(e, i)
    end
  end

  def test_examples_attributes=(attrs)
    self.test_examples = attrs.map do |k, v|
      [k.to_i, v]
    end.sort_by(&:first).map(&:last).reject { |v| v[:tester].empty? }
  end
end
