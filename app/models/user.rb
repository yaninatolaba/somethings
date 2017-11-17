class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable



  	belongs_to :university, optional: true
	has_many :questions
	has_many :comments
	has_many :answers
	default_scope -> { order :apellido }

	#validates :terms_of_service, acceptance: true



	
	validates :nombre, :presence => {:message => "Usted debe ingresar un nombre"}, length: {minimum: 2, maximum: 20, :message => "El nombre debe tener entre 2 y 20 caracteres"}

	validates :apellido, :presence => {:message => "Usted debe ingresar un apellido"}, length: {minimum: 2, maximum: 20, :message => "El apellido debe tener entre 2 y 20 caracteres"}
	validates :email, :presence => {:message => "El email no puede estar en blanco!"}, :uniqueness => {:message => "Usted ha ingresado un mail ya usado! Intente con otro"}
	validates :password, :presence => {:message => "La contraseña no puede estar en blanco!"}


end


