//= require spec_helper

describe('MethodTodo object', function()
    {
      beforeEach(function() {
        this.server = sinon.fakeServer.create();
        }
      );

      it("should instantiate", function()
        {
          MethodTodo.init({});
          expect($.isEmptyObject(MethodTodo.Models)).to.equal(false);
          expect($.isEmptyObject(MethodTodo.Collections)).to.equal(false);
          expect($.isEmptyObject(MethodTodo.Routers)).to.equal(false);
          expect($.isEmptyObject(MethodTodo.Globals)).to.equal(false);
        }
      );

    }
);
