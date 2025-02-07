# frozen_string_literal: true

require 'spec_helper'

describe 'exec_idempotency' do
  let(:msg) { 'exec without idempotency. set at least one of the attributes: onlyif, unless, creates, refreshonly' }

  context 'with fix disabled' do
    context 'correct exec resource declarations' do
      let(:code) do
        <<~EOS_WITHOUT_FAILURES
          exec { '/bin/touch /tmp/test':
            timeout => 10,
            creates => '/tmp/test',
          }
          exec { '/bin/foo':
            unless => '/bin/false',
            tries  => 5,
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
        <<~EOS_WITH_FAILURES
          exec { '/bin/apt update': }
        EOS_WITH_FAILURES
      end

      it 'detects problems' do
        expect(problems.size).to eq(1)
      end

      it 'creates a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(25)
      end
    end

    context 'with unless used in an attribute value' do
      let(:code) do
        <<~CODE
          exec { '/bin/touch /tmp/test':
            environment => unless $facts['kernel'] == 'Linux' { ['HOME=/opt/root'] }
          }
        CODE
      end

      it 'detects problems' do
        expect(problems.size).to eq(1)
      end
    end

    context 'with other resources' do
      let(:code) do
        <<~CODE
          notify { 'test': }
        CODE
      end

      it 'detects no problems' do
        expect(problems.size).to eq(0)
      end
    end

    context 'with idempotent attribute on single line' do
      let(:code) do
        <<~CODE
          exec { '/bin/touch /tmp/test': creates => '/tmp/test' }
        CODE
      end

      it 'detects no problems' do
        expect(problems.size).to eq(0)
      end
    end

    context 'with multiple `;` separated resource bodies including non idempotent resources' do
      let(:code) do
        <<~CODE
          exec {
            '/bin/touch /tmp/test':
              creates => '/tmp/test'
            ;
            '/bin/touch /tmp/test2':
            ;
            '/bin/touch /tmp/test3':
              environment => ['HOME=/root'],
            ;
            '/bin/touch /tmp/test4':
              refreshonly => true,#{' '}
            ;
          }
        CODE
      end

      it 'detects resources that aren\'t idempotent' do
        expect(problems.size).to eq(2)
      end
    end

    context 'with multiple `;` separated resource bodies including a single non idempotent resources' do
      let(:code) do
        <<~CODE
          exec {
            '/bin/touch /tmp/test':
              creates => '/tmp/test'
            ;
            '/bin/touch /tmp/test3':
              environment => ['HOME=/root'],
            ;
            '/bin/touch /tmp/test4':
              refreshonly => true,#{' '}
            ;
          }
        CODE
      end

      it 'detects resources that aren\'t idempotent' do
        expect(problems.size).to eq(1)
      end

      it 'creates a warning' do
        expect(problems).to contain_warning(msg).on_line(5).in_column(26)
      end
    end

    context 'with resource defaults containing idempotent attribute and a separate non idempotent exec' do
      let(:code) do
        <<~CODE
          exec {
            default:
              refreshonly => true,
            ;
            '/bin/touch /tmp/idempotent':
            ;
            '/bin/touch /tmp/idempotent2':
            ;
          }

          exec { '/bin/touch /tmp/not_idempotent': }
        CODE
      end

      it 'detects just one problem' do
        pending(
          'Detecting whether an exec resource falls inside a resource declarion with default attributes is difficult and currently not supported',
        )
        expect(problems.size).to eq(1)
      end
    end
  end
end
