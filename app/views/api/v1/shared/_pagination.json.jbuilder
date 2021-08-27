page = page.to_i.positive? ? page.to_i : 1
limit = per_page.to_i.positive? ? per_page.to_i : 20
json.page page
json.per_page limit
json.total total_count
json.total_pages (total_count.to_f / limit).ceil
