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
        EXEC {
          path => '/bin',
        }
        exec { '/bin/apt update': }
        exec { 'foo': }
        EOS_WITH_FAILURES
      end

      it 'detects problems' do
        expect(problems.size).to eq(2)
      end

      it 'creates a first warning' do
        expect(problems).to contain_warning(msg).on_line(4).in_column(33)
      end

      it 'creates a second warning' do
        expect(problems).to contain_warning(msg).on_line(5).in_column(21)
      end
    end
  end
end
