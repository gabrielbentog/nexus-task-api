class Api::ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include LoggableRequest

  before_action :authenticate_api_user!
  skip_before_action :authenticate_api_user!, if: :devise_controller?
  before_action :underscore_params!
  before_action :touch_user_activity
  before_action :set_current_context
  after_action :camelize_response

  def underscore_params!
    # 1. Identifica a chave que o Rails gera automaticamente (ex: 'project_column')
    # O Rails usa o nome do controller para o 'wrap_parameters'
    auto_wrapped_key = controller_name.singularize

    # 2. Se a chave gerada automaticamente existe e está vazia ou é igual a um
    # objeto que veio em camelCase, nós a removemos para evitar a colisão fatal.
    if params.has_key?(auto_wrapped_key) && params[auto_wrapped_key].blank?
      params.delete(auto_wrapped_key)
    end

    # 3. Agora transformamos tudo com segurança.
    # O 'projectColumn' virará 'project_column' sem ser sobrescrito por um hash vazio.
    params.deep_transform_keys!(&:underscore)
  end

  def generate_meta(collection, extra: {})
    {
      pagination: {
        total_count:  collection.total_count,
        total_pages:  collection.total_pages,
        current_page: collection.current_page,
        per_page:     collection.limit_value
      }
    }.merge(extra.symbolize_keys)
  end

  def camelize_response
    return unless response.media_type == 'application/json'

    body = response.body.presence && JSON.parse(response.body) rescue nil
    return unless body

    camelized = body.deep_transform_keys { |key| key.to_s.camelize(:lower) }
    response.body = camelized.to_json
  end

  def touch_user_activity
    return if current_api_user.nil?

    if current_api_user.last_activity_at.nil? || current_api_user.last_activity_at < 5.minutes.ago
      current_api_user.update_column(:last_activity_at, Time.current)
    end
  end

  private

  def set_current_context
    Current.user       = current_api_user
    Current.request_id = request.uuid
  end
end
