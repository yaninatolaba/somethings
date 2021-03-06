class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :downvote, :upvote]
  # GET /questions
  # GET /questions.json
  def index
    if params[:query].present?
      @questions = Question.search(params[:query])
      @query = params[:query]
    else  
      @questions = Question.fecha
    end
  end

  def buscare
      @questions = Question.includes(:tags).where('tags.id' => params['tag_ids']).all
      @numero = params['tag_ids']
      @tags = Tag.all
  end
  
  def mina
      @questions = Question.min
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @answer = Answer.new
    @comment_question = CommentQuestion.new
    @comment_report_question = CommentReportQuestion.new
    @question_report = QuestionReport.new
    @comment_report_answer = CommentReportAnswer.new
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  def mifacu
    @questions = Question.facu(current_user.university_id)
  end

   def mispreguntas
      @questions = Question.mio(current_user.id)
  end  

  # POST /questions
  # POST /questions.json
  def create
    @question = current_user.questions.new(question_params)
    if current_user.university != nil 
      @question.university_id = current_user.university_id
    end
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'La pregunta fue creado correctamente.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'La pregunta fue modificada correctamente.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'La pregunta ha sido eliminada!' }
      format.json { head :no_content }
    end
  end

  def upvote 
    @question.upvote_from current_user
    @question.user.puntaje+=5
    @question.user.save
    redirect_to @question, notice: 'Gracias por puntuar!'
  end

  
    #para el viw de answer
  #link_to 'Votar', voto_positivo_answer_path(answer.id)
  def downvote
    @question.downvote_from current_user
     #si votas negativo automaticamente el usuario logueaado tiene un punto negativo -1
    @question.user.puntaje-=2
    @question.user.save

    current_user.puntaje-=1
    current_user.save
    redirect_to @question, notice: 'Gracias por puntuar'
  end

  def asigna_mejor_respuesta
    @question = Question.find(params[:id])
    @answer = Answer.find(params[:answer_id])
    @question.best_answer_id = @answer.id
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Se ha elegido una mejor respuesta!' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:titulo, :descripcion, :user_id, :university_id, :tag_ids => [])
    end
end