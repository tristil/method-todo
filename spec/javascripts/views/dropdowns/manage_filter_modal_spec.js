describe('ManageFilterModal object', function()
    {
      beforeEach(function() {
        setFixtures("<div id='manage-filters-modal'></div>");
        this.collection = new MethodTodo.Collections.Contexts();
        this.dropdown = new MethodTodo.Views.Dropdown(
          {
            parent : null,
            dropdown_type : 'context',
            collection : this.collection
          }
        );
      });

      it("should instantiate with required options array", function()
        {
          var self = this;
          expect(function(){new MethodTodo.Views.ManageFilterModal()}).toThrow();
          expect(
            function(){new MethodTodo.Views.ManageFilterModal(
              {filter_type: 'context', parent : self.dropdown })}
            ).not.toThrow();
        }
      );

      it("should set a correct header title", function()
        {
          var modal = new MethodTodo.Views.ManageFilterModal(
            {filter_type: 'context', parent : this.dropdown}
          );
          modal.render();
          expect(modal.$el.find('h3')).toHaveText("Manage Contexts");
        }
      );

      it("should populate data rows", function()
        {
          this.collection.reset([{id : 1, name : 'home'}, {id : 2, name : 'work'}]);
          var modal = new MethodTodo.Views.ManageFilterModal(
            {filter_type: 'context', parent : this.dropdown}
          );
          modal.render();
          expect(modal.$el.find("tbody tr td a#filter-item-1")).toExist();
          expect(modal.$el.find("tbody tr td:contains('work')")).toExist();
        }
      );

      it("should display confirmation dialog after clicking on delete button", function()
          {
            this.collection.reset([{id : 1, name : 'home'}, {id : 2, name : 'work'}]);
            var modal = new MethodTodo.Views.ManageFilterModal(
              {filter_type: 'context', parent : this.dropdown}
            );
            modal.render();

            $('#filter-item-1').click();

            waitsFor( function() {
              return $('#manage-filters-confirmation').is(":visible");
            });

          }
      );

      it("should submit request to remove filter from todos", function()
          {
            this.collection.reset([{id : 1, name : 'home'}, {id : 2, name : 'work'}]);
            var modal = new MethodTodo.Views.ManageFilterModal(
              {filter_type: 'context', parent : this.dropdown}
            );
            modal.render();

            // Spy on jQuery's ajax method
            var spy = sinon.spy(jQuery, 'ajax');

            $('#filter-item-1').click();

            waitsFor( function() {
              return $('#manage-filters-confirmation').is(":visible");
            });

            runs(function() {
              $("#remove-filter-button-final").click();
            });

            runs( function() {
              expect(spy).toHaveBeenCalled();
              expect(spy.getCall(0).args[0].url)
                  .toEqual("/contexts/1");
            });

            waitsFor( function() {
              return $('#main-manage-filters').is(":visible");
            });


          }
        );

    }
);

