//= require spec_helper

describe('TodoFilter', function()
    {
      beforeEach(function() {
        this.server = sinon.fakeServer.create();
        }
      );

      it("should instantiate", function()
        {
          new MethodTodo.Views.TodoFilter({parent : null});
        }
      );

      /*
      it("should redraw other elements", function()
        {
          var ActiveTodos = sinon.mock({redraw : function(){}});
          ActiveTodos.expects("redraw");
          var CompletedTodos = sinon.mock({redraw : function(){}});
          CompletedTodos.expects("redraw");
          var filter_header = sinon.mock({refresh : function(){}});
          filter_header.expects("refresh");

          var parent = {
            ActiveTodos : ActiveTodos,
            CompletedTodos : CompletedTodos,
            filter_header : filter_header,
          };

          var todo_filter = new MethodTodo.Views.TodoFilter({parent : parent});
          todo_filter.refresh();
        }
      );
      */

    }
);
