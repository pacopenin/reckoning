module Api
  module V1
    class TimersController < Api::BaseController
      def index
        debugger
        authorize! :index, Timer
        scope = current_user.timers
        scope = scope.where(date: date) if date
        render json: scope.order('created_at ASC'), each_serializer: TimerSerializer, status: :ok
      end

      def create
        authorize! :create, timer
        if timer.save
          render json: timer, status: :created
        else
          Rails.logger.info "Timer Create Failed: #{timer.errors.full_messages.to_yaml}"
          render json: timer.errors, status: :bad_request
        end
      end

      def update
        authorize! :update, timer
        if timer.update(timer_params)
          render json: timer, status: :ok
        else
          Rails.logger.info "Timer Update Failed: #{timer.errors.full_messages.to_yaml}"
          render json: timer.errors, status: :bad_request
        end
      end

      def stop
        authorize! :stop, timer
        if timer.stop
          render json: timer, status: :ok
        else
          Rails.logger.info "Timer Stop Failed: #{timer.to_yaml}"
          render json: { message: I18n.t(:"messages.timer.stop.failure") }, status: :bad_request
        end
      end

      def start
        authorize! :start, timer
        if timer.start
          render json: timer, status: :ok
        else
          Rails.logger.info "Timer Start Failed: #{timer.to_yaml}"
          render json: { message: I18n.t(:"messages.timer.start.failure") }, status: :bad_request
        end
      end

      def destroy
        authorize! :destroy, timer
        if timer.position.blank?
          if timer.destroy
            render json: timer, status: :ok
          else
            Rails.logger.info "Timer Destroy Failed: #{timer.errors.full_messages.to_yaml}"
            render json: timer.errors, status: :bad_request
          end
        else
          Rails.logger.info "Timer Destroy Failed: Timer allready on Invoice"
          render json: { message: I18n.t(:"messages.timer.destroy.failure") }, status: :bad_request
        end
      end

      private def date
        params[:date]
      end

      private def task
        @task ||= current_account.tasks.find(params.delete(:task_uuid))
      end

      private def timer_params
        @timer_params ||= params.permit(:date, :value, :started, :note).merge(
          task_id: task.id,
          user_id: current_user.id
        )
      end

      private def timer
        @timer ||= Timer.where(user_id: current_user.id, id: params.fetch(:id, nil)).first
        @timer ||= Timer.new timer_params
      end
    end
  end
end
