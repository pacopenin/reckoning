# encoding: utf-8
# frozen_string_literal: true
json.uuid project.uuid
json.name project.name
json.label project.label
json.customer_name project.customer_name
json.tasks project.tasks.includes(:timers).order("timers.created_at DESC") do |task|
  json.partial! "api/v1/projects/tasks", task: task
end
json.created_at project.created_at
json.updated_at project.updated_at
json.links do
  json.show do
    json.href v1_project_path(project.id)
  end
end
