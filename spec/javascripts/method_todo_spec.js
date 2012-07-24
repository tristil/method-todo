describe('MethodTodo object', function()
    {
      beforeEach(function() {
        this.server = sinon.fakeServer.create();
        }
      );

      it("should instantiate", function()
        {
          MethodTodo.init({});
          expect($.isEmptyObject(MethodTodo.Models)).toBe(false);
          expect($.isEmptyObject(MethodTodo.Collections)).toBe(false);
          expect($.isEmptyObject(MethodTodo.Routers)).toBe(false);
          expect($.isEmptyObject(MethodTodo.Globals)).toBe(false);
        }
      );

    }
);
