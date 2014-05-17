Account = { balance = 0,
            withdraw = function (self, v)
                         self.balance = self.balance - v
                       end
          }