describe('Todos Collection', function()
    {

      beforeEach(function() {
        this.server = sinon.fakeServer.create();
        }
      );

      it("should instantiate", function()
        {
          new MethodTodo.Collections.Todos();
        }
      );

      describe("#getFilteredUrl", function()
        {
          beforeEach(function()
            {
              this.todo_filter = new MethodTodo.Views.TodoFilter({parent : null});
              MethodTodo.Globals.TodoFilter = this.todo_filter;
              this.todo_collection = new MethodTodo.Collections.Todos();
            }
          );

          it("should be empty if no values are set on TodoFilter", function()
            {
              this.todo_collection.url= '/todos/';
              expect(this.todo_collection.getFilteredUrl()).toEqual('/todos/?');

              this.todo_collection.url= '/todos/?completed=1';
              expect(this.todo_collection.getFilteredUrl()).toEqual('/todos/?completed=1&');
            }
          );

          it("should reflect values of TodoFilter", function()
            {
              this.todo_filter.context_id = 1;
              this.todo_collection.url= '/todos/';
              expect(this.todo_collection.getFilteredUrl()).toEqual('/todos/?context_id=1');

              this.todo_collection.url= '/todos/?completed=1';
              expect(this.todo_collection.getFilteredUrl()).toEqual('/todos/?completed=1&context_id=1');

              this.todo_filter.project_id = 1;
              expect(this.todo_collection.getFilteredUrl()).toEqual('/todos/?completed=1&context_id=1&project_id=1');
              this.todo_collection.url= '/todos/';
              expect(this.todo_collection.getFilteredUrl()).toEqual('/todos/?context_id=1&project_id=1');
            }
          );
        }
      );

    }
);
