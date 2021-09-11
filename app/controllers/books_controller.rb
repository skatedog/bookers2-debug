class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    # 解答1
    # (favoritesを含む)本をすべて取得し、本が持つ(期間内に作成された)favoriteの数が多い順に本を並び変える。
    @books = sorted_books

    # 解答2 問題点：期間内にfavoriteされていないbookについては表示されない。
    #
    # 期間内に作成されたfavoriteをbook_idごとに集計し、数が多い順に並び替え、その並び順でidを配列形式に取得する。
    # book_ids = Favorite.where(created_at: from...to).group(:book_id).order("count(*) desc").pluck(:book_id)
    # idの配列をもとに、Bookインスタンスを生成する。
    # @books = Book.find(book_ids)

    # 解答3(DWC) 問題点:期間外に作成されたユーザーが作成したいいねは並び替えをする際にカウントされない。
    # (favorited_usersを含む)本をすべて取得し、本に対していいねをした、(期間内に作成された)userの数が多い順に本を並び変える。
    # @books = Book.includes(:favorited_users).
    #   sort {|a,b|
    #     b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
    #     a.favorited_users.includes(:favorites).where(created_at: from...to).size
    #   }

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = sorted_books
      render 'index'
    end
  end

  def edit
    if @book.user != current_user
      redirect_to books_path
    end
  end


  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def sorted_books
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day

    Book.includes(:favorites).sort do |a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
