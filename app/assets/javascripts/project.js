var Project = Backbone.Model;

var ProjectList = Backbone.Collection.extend({
  model : Project,
  url   : '/projects'
}
);

Projects = new ProjectList();


