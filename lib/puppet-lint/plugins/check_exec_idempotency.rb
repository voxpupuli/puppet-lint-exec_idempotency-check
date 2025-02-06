# frozen_string_literal: true

PuppetLint.new_check(:exec_idempotency) do
  def check
    resource_indexes.each do |resource|
      next unless resource[:type].value == 'exec'

      check_result = resource[:tokens].any? do |t|
        (t.type == :NAME && (t.value == 'creates' || t.value == 'onlyif' || t.value == 'refreshonly')) || (t.type == :UNLESS && t.value == 'unless')
      end
      next if check_result

      attr = resource[:tokens]

      #      pp attr
      token = attr[0]
      notify :warning, {
        message: 'exec without idempotency. set at least one of the attributes: onlyif, unless, creates, refreshonly',
        line: token.line,
        column: token.column,
        token: token,
        resource: resource
      }
    end
  end
end
