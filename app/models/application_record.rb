class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.paginate(page: nil, per_page: nil)
    page = page.to_i.positive? ? page.to_i : 1
    limit = per_page.to_i.positive? ? per_page.to_i : 20
    start = (page - 1) * limit
    pagination(limit, start)
  end

  class << self
    private

    def pagination(limit, start)
      limit(limit).offset(start)
    end
  end
end
