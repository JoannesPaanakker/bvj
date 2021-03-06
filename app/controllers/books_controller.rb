
class BooksController < ApplicationController
  respond_to :html, :json, :js
  skip_before_action :authenticate_user!, only: [:new, :show, :createa, :updatea, :edit, :update, :create, :update_textblock]

  def show
    @book = Book.find(params[:id])
    @booktemplate = Booktemplate.find(@book.booktemplate_id)
    @pagetemplates = Pagetemplate.where(booktemplate_id: @booktemplate)
    @booktexts = Booktext.where(book_id: @book.id)
    @booktext = @booktexts[0]
    @booktemplatetexts = Booktemplatetext.where(booktemplate_id: @booktemplate)
  end

  def new
    @book = Book.new
    @booktemplate = Booktemplate.find(params[:format])
    @pagetemplates = Pagetemplate.where(booktemplate_id: @booktemplate.id)
    @subcategory = Subcategory.find(@booktemplate.subcategory_id)
    @questions = Question.where(subcategory_id: @subcategory.id)
    @book.booktemplate_id = @booktemplate.id
    @book.save!
    @questions.each do |q|
      @bookanswer = Bookanswer.new
      @bookanswer.question_id = q.id
      @bookanswer.book_id = @book.id
      @bookanswer.save!
    end
  end

  def edit
    @save = true
    @book = Book.find(params[:id])
    @booktemplates = Booktemplate.all
    @booktemplate = Booktemplate.find(@book.booktemplate_id)
    @booktextsnew = @book.booktexts
    # @booktemplateimages = Booktemplateimage.where(booktemplate_id: @booktemplate)
    # @btimages = []
    # @booktemplateimages.each do |bti|
    #   img = Image.find(bti.image_id)
    #   @btimages << img.filename
    # end
    # now only two galleries. This will be relative: boottemplate_id <=> gallery_id's
    @images1 = Image.where(imagegallery_id: 1)
    @images1_ids = []
    @images1.each do |i1|
      @images1_ids << i1.id
    end
    @images2 = Image.where(imagegallery_id: 2)
    @images2_ids = []
    @images2.each do |i2|
      @images2_ids << i2.id
    end
    # get all imagecategory ids
    @imagecategories = Imagecategory.all
    @imagecategory_ids = []
    @imagecategories.each do |ic|
      @imagecategory_ids << [ ic.id , ic.name ]
    end
    @categoryimages = Categoryimage.all
    @array_of_all_image_ids = []
    @categoryimages.each do |ci|
      @array_of_all_image_ids << "img" + ci.image_id.to_s
    end

    # @array_of_all_image_ids = @array_of_all_image.map(&:to_s).join("")

    # array of arrays: array of category-filename arrays
    @allcategories = []
    # get image filenames per category
    @imagecategory_ids.each do |icid|
      @imgs_filtered_by_cat = Categoryimage.where(imagecategory_id: icid)
      @img_names_per_category = []
      @imgs_filtered_by_cat.each do |cat|
        tt = Image.find(cat.image_id)
        @img_names_per_category << tt
      end
      @allcategories << @img_names_per_category
    end
  end

  def bookedit2
    @book = Book.find(params[:id])
    get_book_templates
    @booktemplate = Booktemplate.find(@book.booktemplate_id)
    render layout: "devise"
  end

  def update
    @book = Book.find(params[:id])
    @book.update!(book_params)
    respond_to do |format|
        format.js
        format.html { redirect_to new_order_path(:book_id => @book) }
    end
  end

  def updatea
    @book = Book.find(params[:id])
    @book.update!(book_params)
    respond_to do |format|
        format.js
    end
  end

  def create
    @book = Book.new(book_params)
    @book.save!
    respond_to do |format|
      format.js
    end
  end

  def update_textblock
    @book = Book.find(params[:id])
    index = params[:textblock].to_i
    indeks = index - 1
    @book.booktexts[indeks] = params[:text]
    @book.update!(booktexts: @book.booktexts)
  end

  private

  def book_params
    params.require(:book).permit(
      :booktemplate_id,
      :buyer_id,
      :name,
      :email,
      :company,
      :sender,
      :streetname_and_number,
      :postalcode,
      :city,
      :country,
      :phonenumber,
      :addressee,
      :company2,
      :streetname_and_number2,
      :postalcode_city2,
      :country2,
      :booktexts,
      :afleveradreshetzelfde
      )
  end
end
