class Api::V1::UsuariosController < ApplicationController
  def index
    @usuarios = Usuario.buscar(index_params[:busqueda])

    render formats: :json
  end

  def show
    @usuario = Usuario.find(show_params[:id])

    render formats: :json
  end

  def create
    @usuario = Usuario.new(create_params)
    
    raise ExceptionApi, @usuario.errors.full_messages.join(', ') unless @usuario.save
    render :show, formats: :json
  end

  def update_email
    @usuario = Usuario.find(update_email_params[:id])
    @usuario.email = update_email_params[:email]
    
    raise ExceptionApi, @usuario.errors.full_messages.join(', ') unless @usuario.save
    render :show, formats: :json
  end

  def update_nombre
    @usuario = Usuario.find(update_nombre_params[:id])
    @usuario.nombre = update_nombre_params[:nombre]
    
    raise ExceptionApi, @usuario.errors.full_messages.join(', ') unless @usuario.save
    render :show, formats: :json
  end

  def destroy
    @usuario = Usuario.find(destroy_params[:id])
    raise ExceptionApi, @usuario.errors.full_messages.join(', ') unless @usuario.destroy
    @usuario = Usuario.new
    render :show, formats: :json
  end

  private
  
  def index_params
    params.permit(:busqueda, :page, :per_page)
  end

  def show_params
    params.permit(:id)
  end

  def create_params
    params.permit(:nombre, :email)
  end

  def update_email_params
    params.permit(:id, :email)
  end

  def update_nombre_params
    params.permit(:id, :nombre)
  end

  def destroy_params
    params.permit(:id)
  end
end
