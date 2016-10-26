module ApplicationHelper
  def full_title page_title = ""
    base_title = t ".ruby_sample_app"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end
