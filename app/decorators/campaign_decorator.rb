class CampaignDecorator < Draper::Decorator
  delegate_all

  def name
    object.name.titleize
  end

  def goal
    h.number_to_currency object.goal
  end

  def end_date
    h.formatted_date_time object.end_date
  end

  def state_label
    bootstrap_classes = {"published" => "label-success",
                         "draft" => "label-info",
                         "unfunded" => "label-danger",
                         "funded" => "label-default",
                         "cancelled" => "label-warning",
                        }

    h.content_tag :div, class: "label #{bootstrap_classes[object.aasm_state]}" do
        object.aasm_state
    end
  end

  def publish_button
    if object.draft?
      h.link_to "Publish", campaign_publishings_path(object), method: :post, class: "btn btn-success-outline"
    end
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
