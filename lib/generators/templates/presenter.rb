<% module_namespacing do -%>
class <%= class_name %>Presenter < Keynote::Presenter
<% if targets.any? -%>
  presents <%= targets.map { |t| ":#{t}" }.join(', ') %>
<% end -%>
end
<% end -%>
