module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |_error|
      render partial: 'api/v1/exceptions_handler/record_not_found', status: :not_found, formats: :json
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { message: error.message, status: :unprocessable_entity }, status: :unprocessable_entity
    end

    rescue_from ArgumentError do
      render partial: 'api/v1/exceptions_handler/argument_error', status: :bad_request, formats: :json
    end

    rescue_from ExceptionApi do |error|
      render partial: 'api/v1/exceptions_handler/model_error',
              locals: { error: error },
              status: :unprocessable_entity,
              formats: :json
    end
  end
end
