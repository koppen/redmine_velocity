class VelocitiesController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:id])

    @recent_versions = @project.versions.find(:all,
      :conditions => ["effective_date <= ?", Time.now],
      :order => 'effective_date DESC',
      :limit => 5
    )
    @current_version = @recent_versions.first

    @version_story_points = @recent_versions.collect { |version| custom_field_sum(version.fixed_issues) }
    @current_velocity = average(@version_story_points).floor

    @backlogged_points = custom_field_sum(@project.issues.open)
  end

  def custom_field_sum(issues, custom_field_name = 'Story points')
    # TODO: Decorate Version instead
    custom_field_values = issues.collect { |issue|
      issue.custom_field_values.select { |cv|
        cv.custom_field.name.downcase == custom_field_name.downcase
      }
    }.flatten.collect(&:value).reject(&:blank?).collect(&:to_i).sum
  end
  helper_method :custom_field_sum

  def average(array)
    array.sum.to_f / array.size
  end
end
