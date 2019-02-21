class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :video]

  def home
    get_category_names_alphabetically_ordered
  end

  private

  def get_category_names_alphabetically_ordered
    @category_names = []
    Category.all.each do |category|
      @category_names << category.name
    end
    @category_names.sort_by!{ |c| c.downcase }
    @category_names.insert(0,"Todas las categorias")
    return @category_names
  end
end
