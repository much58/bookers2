class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  def index
    @book = Book.new #新規投稿用
    @books = Book.all
    @user = User.find(current_user.id)
  end
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      @user = User.find(current_user.id)
      render :index
    end
  end
  def show
    @book = Book.find(params[:id])
    @user = @book.user
    # @user = User.find(@books.user_id)
    @book_new = Book.new
    @book_comment = BookComment.new
  end
  def edit
    @book = Book.find(params[:id])
  end
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render :edit
    end
  end
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end
  def correct_user
    book = Book.find(params[:id])
    user = book.user
    redirect_to(books_path) unless user == current_user
  end
end
