require "rails_helper"

RSpec.describe ParcelasContaPagarsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/parcelas_conta_pagars").to route_to("parcelas_conta_pagars#index")
    end

    it "routes to #show" do
      expect(get: "/parcelas_conta_pagars/1").to route_to("parcelas_conta_pagars#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/parcelas_conta_pagars").to route_to("parcelas_conta_pagars#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/parcelas_conta_pagars/1").to route_to("parcelas_conta_pagars#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/parcelas_conta_pagars/1").to route_to("parcelas_conta_pagars#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/parcelas_conta_pagars/1").to route_to("parcelas_conta_pagars#destroy", id: "1")
    end
  end
end
