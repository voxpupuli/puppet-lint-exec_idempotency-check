# frozen_string_literal: true

EXEC_IDEMPOTENCY_ATTRIBUTES = %w[onlyif unless creates refreshonly].freeze

PuppetLint.new_check(:exec_idempotency) do
  def check
    resource_indexes.each do |resource|
      next unless resource[:type].value == 'exec'
      next if idempotent?(exec_attributes(resource))

      first_token = resource[:tokens].first

      notify :warning, {
        message: "exec without idempotency. set at least one of the attributes: #{EXEC_IDEMPOTENCY_ATTRIBUTES.join(', ')}",
        line: first_token.line,
        column: first_token.column,
        token: first_token,
        resource: resource,
      }
    end
  end

  private

  # Due to https://github.com/puppetlabs/puppet-lint/issues/232 we use our own helper to extract the resource attributes
  def exec_attributes(resource)
    tokens = resource[:tokens]

    attributes = []
    iter_token = tokens.first.prev_token

    until iter_token.nil?
      iter_token = iter_token.next_token_of(%i[NAME UNLESS])
      break unless tokens.include?(iter_token)

      attributes << iter_token.value if iter_token.next_code_token && iter_token.next_code_token.type == :FARROW
    end

    attributes
  end

  def idempotent?(attributes)
    attributes.any? do |attribute|
      EXEC_IDEMPOTENCY_ATTRIBUTES.include?(attribute)
    end
  end
end
