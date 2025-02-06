# frozen_string_literal: true

require 'spec_helper'

describe 'exec_idempotency' do
  let(:msg) { 'exec without idempotency. set at least one of the attributes: onlyif, unless, creates, refreshonly' }

  context 'with fix disabled' do
    context 'correct exec resource declarations' do
      let(:code) do
        <<-EOS_WITHOUT_FAILURES
        exec { '/bin/touch /tmp/test':
          creates => '/tmp/test',
        }
        exec { '/bin/foo':
          unless => '/bin/false',
        }
        exec { '/bin/bar':
          onlyif => '/bin/true',
        }
        exec { '/bin/baz':
          refreshonly => true,
        }
        EOS_WITHOUT_FAILURES
      end

      it 'does not detect any problems' do
        expect(problems.size).to eq(0)
      end
    end

    context 'wrong exec resource declarations' do
      let(:code) do
        <<-EOS_WITH_FAILURES
        exec { '/bin/apt update': }
        EOS_WITH_FAILURES
      end

      it 'detects problems' do
        expect(problems.size).to eq(1)
      end

      it 'creates a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(33)
      end
    end
  end
end
