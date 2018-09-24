class BooksController < ApplicationController
  respond_to :html, :json, :js
  skip_before_action :authenticate_user!, only: [:new, :show, :createa, :edit]

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
    @book = Book.find(params[:id])
    @booktemplate = Booktemplate.find(@book.booktemplate_id)
    @pagetemplates = Pagetemplate.where(booktemplate_id: @booktemplate)
    # this should be part of book: @book.text1, ....2, ...3 ect
    @booktexts = Booktext.where(book_id: @book.id)
    @booktemplateimages = Booktemplateimage.where(booktemplate_id: @booktemplate)
    @btimages = []
    @booktemplateimages.each do |bti|
      img = Image.find(bti.image_id)
      @btimages << img.filename
    end
  end

  def update

  end

  def createa
    # create book first
    @book = Book.new(book_params)
    @book.save!
    # now create booktext
    @booktext = Booktext.new(booktext_params)
    @booktext.book_id = @book.id
    @booktext.save!
    respond_to do |format|
        format.js
    end
  end

  def create
    @book = Book.new(book_params)
    @bookanswer.save!
  end

  private

  def booktext_params
    params.permit(:text1, :text2, :text3, :text4, :text5, :text6, :text7, :text8, :text9, :text10, :text11, :text12, :text13, :text14, :text15, :text16, :text17, :id)
  end

  def book_params
    params.permit(:booktemplate_id, :buyer_id, :name)
  end
end
