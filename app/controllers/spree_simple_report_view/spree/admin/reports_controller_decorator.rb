module SpreeSimpleReportView
  module Spree
  	module Admin
  		module ReportsControllerDecorator

        def self.prepended(base)
          base.before_action :add_custom_reports, only: :index
        end

	      def out_of_stock
          params[:q] = {} unless params[:q]
          if params[:q].present? && params[:q][:updated_at_gt].present?
            params[:q][:updated_at_gt] = Time.zone.parse(params[:q][:updated_at_gt]).beginning_of_day rescue ""
          end
          if params[:q].present? && params[:q][:updated_at_lt].present?
            params[:q][:updated_at_lt] = Time.zone.parse(params[:q][:updated_at_lt]).end_of_day rescue ""
          end
          @search = ::Spree::Variant.ransack(params[:q])
          @variants = ::Spree::Variant.includes(:stock_items).where("spree_stock_items.count_on_hand = 0").references(:spree_stock_items)
	      end

        def add_custom_reports
          ::Spree::Admin::ReportsController.add_available_report!(:out_of_stock)
        end
	    end
  	end
  end
end

::Spree::Admin::ReportsController.prepend SpreeSimpleReportView::Spree::Admin::ReportsControllerDecorator