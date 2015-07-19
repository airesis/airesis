RSpec.configure do |config|
  config.before(:each, notifications: true) do
    allow_any_instance_of(AlertJob).to receive(:sidekiq_job) do |alert_job|
      AlertsWorker.jobs.select { |job| job['jid'] == alert_job.jid }[0]
    end
    allow_any_instance_of(AlertJob).to receive(:reschedule)

    allow_any_instance_of(EmailJob).to receive(:sidekiq_job) do |email_job|
      EmailsWorker.jobs.select { |job| job['jid'] == email_job.jid }[0]
    end
    allow_any_instance_of(EmailJob).to receive(:reschedule)
  end
end

def cumulable_event_process_spec
  before(:each) do
    load_database
    trigger_event
  end

  it 'schedule an event' do
    expect(event_class.jobs.size).to eq 1
  end

  context 'event chain running' do

    before(:each) do
      event_class.drain
    end

    context 'another event happens in the meantime, before alerts are sent' do
      before(:each) do
        trigger_event
      end

      it 'schedule another event' do
        expect(event_class.jobs.size).to eq 1
      end

      context 'event chain running' do
        before(:each) do
          event_class.drain
        end

        it 'does not schedule other alerts' do
          expect(AlertJob.count).to eq expected_alerts
        end

        it 'accumulates on the alerts in queue already' do
          AlertJob.all.each do |alert_job|
            expect(alert_job.accumulated_count).to eq 2
          end
        end
      end
    end

    it 'schedule alerts' do
      expect(AlertJob.count).to eq expected_alerts
      expect(AlertsWorker.jobs.size).to eq expected_alerts
      AlertJob.all.each do |alert_job|
        expect(alert_job.scheduled?).to be_truthy
      end
    end

    context 'alerts chain running' do
      before(:each) do
        AlertsWorker.drain
      end

      context 'another event happens in the meantime, before emails are sent' do
        before(:each) do
          trigger_event
        end

        it 'schedule another event' do
          expect(event_class.jobs.size).to eq 1
        end

        context 'event chain running' do
          before(:each) do
            event_class.drain
          end

          it 'does not schedule other alerts' do
            expect(AlertJob.any?).to be_falsey
          end

          it 'accumulates on the alerts sent already' do
            Alert.all.each do |alert|
              expect(alert.properties['count'].to_i).to eq 2
              expect(Alert.last.message).to eq I18n.t("db.notification_types.#{notification_type.name}.message.other", alert.data)
            end
          end

          it 'does not schedule other emails' do
            expect(EmailsWorker.jobs.size).to eq expected_alerts
          end

          context 'emails chain running' do
            before(:each) do
              Alert.all.each do |alert|
                expect(alert.properties['count'].to_i).to eq 2
              end
              EmailsWorker.drain
            end

            it 'sends email correctly' do
              last_deliveries = ActionMailer::Base.deliveries.last(expected_alerts)
              expect(last_deliveries.sample.subject).to include I18n.t("db.notification_types.#{notification_type.name}.email_subject.other", Alert.last.data)
            end
          end
        end
      end

      it 'are sent to users' do
        expect(Alert.unscoped.count).to eq expected_alerts
        Alert.all.each do |alert|
          expect(alert.notification_type).to eq notification_type
          expect(alert.properties['count'].to_i).to eq 1
          expect(alert.message).to eq I18n.t("db.notification_types.#{notification_type.name}.message.one", alert.data)
        end
      end

      it 'emails are scheduled' do
        expect(EmailJob.count).to eq expected_alerts
        expect(EmailsWorker.jobs.size).to eq expected_alerts
        EmailJob.all.each do |email_job|
          expect(email_job.scheduled?).to be_truthy
        end
      end

      context 'emails chain running' do
        before(:each) do
          EmailsWorker.drain
        end

        it 'sends email correctly' do
          last_deliveries = ActionMailer::Base.deliveries.last(expected_alerts)
          expect(last_deliveries.sample.subject).to include I18n.t("db.notification_types.#{notification_type.name}.email_subject.one", Alert.last.data)
        end

        context 'another event happens before the user check the alerts' do
          before(:each) do
            trigger_event
          end

          it 'schedule another event' do
            expect(event_class.jobs.size).to eq 1
          end

          context 'event chain running' do
            before(:each) do
              event_class.drain
            end

            it 'does not schedule other alerts' do
              expect(AlertJob.any?).to be_falsey
            end

            it 'accumulates on the alerts sent already' do
              Alert.all.each do |alert|
                expect(alert.properties['count'].to_i).to eq 2
                expect(Alert.last.message).to eq I18n.t("db.notification_types.#{notification_type.name}.message.other", alert.data)
              end
            end

            it 'schedule new emails' do
              expect(EmailsWorker.jobs.size).to eq expected_alerts
            end
          end
        end
      end
    end
  end
end


def event_process_spec
  before(:each) do
    trigger_event
  end

  it 'schedules the event chain' do
    expect(described_class.jobs.size).to eq 1
  end

  context 'event chain' do
    before(:each) do
      described_class.drain
    end

    it 'schedules the alerts' do
      expect(AlertJob.count).to eq expected_alerts
    end

    context 'alerts chain' do
      before(:each) do
        AlertsWorker.drain
      end

      it 'sent alerts correctly' do
        expect(Alert.unscoped.count).to eq expected_alerts
        expect(Alert.last(3).map { |a| a.user }).to match_array receivers
        expect(Alert.last.notification_type.id).to eq notification_type
      end

      it 'scheduled the emails' do
        expect(EmailsWorker.jobs.size).to eq expected_alerts
      end

      context 'emails chain' do
        before(:each) do
          EmailsWorker.drain
        end

        it 'send emails correctly' do
          last_deliveries = ActionMailer::Base.deliveries.last(3)

          emails = last_deliveries.map { |m| m.to[0] }
          receiver_emails = receivers.map(&:email)

          expect(emails).to match_array receiver_emails
        end
      end
    end
  end
end
