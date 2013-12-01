//= require spec_helper

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
          expect(function(){new MethodTodo.Views.ManageFilterModal()}).to.throw();
          expect(
            function(){new MethodTodo.Views.ManageFilterModal(
              {filter_type: 'context', parent : self.dropdown })}
            ).not.to.throw();
        }
      );

      it("should set a correct header title", function()
        {
          var modal = new MethodTodo.Views.ManageFilterModal(
            {filter_type: 'context', parent : this.dropdown}
          );
          modal.render();
          expect(modal.$el.find('h3').text()).to.equal("Manage Contexts");
        }
      );

      it("should populate data rows", function()
        {
          this.collection.reset([{id : 1, name : 'home'}, {id : 2, name : 'work'}]);
          var modal = new MethodTodo.Views.ManageFilterModal(
            {filter_type: 'context', parent : this.dropdown}
          );
          modal.render();
          expect(modal.$el.find("tbody tr td a#filter-item-1")).to.exist;
          expect(modal.$el.find("tbody tr td:contains('work')")).to.exist;
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

            $('#manage-filters-confirmation').is(":visible").should.beTrue;

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

            $('#manage-filters-confirmation').is(":visible").should.beTrue;

            $("#remove-filter-button-final").click();

            expect(spy).to.have.been.called;
            expect(spy.getCall(0).args[0].url).to.equal("/contexts/1");

            // Can't test this atm because I'm blocking the success callback on
            // $.ajax
            //
            //waitsFor( function() {
              //return $('#main-manage-filters').is(":visible");
            //});

          }
        );

    }
);

