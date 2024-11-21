class Task < ApplicationRecord
  enum :category, {knowledge: 0, skill: 1, risk_mitigation: 2, custom: 3}
end
