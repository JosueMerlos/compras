total_count = @usuarios.length
json.usuarios @usuarios.paginate(page: params[:page], per_page: params[:per_page]), :id, :email, :nombre
json.partial! 'api/v1/shared/pagination', page: params[:page], per_page: params[:per_page], total_count: total_count
