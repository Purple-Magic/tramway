# frozen_string_literal: true

{
  ru: {
    i18n: {
      plural: {
        keys: %i[zero one few many],
        rule: lambda do |n|
          if n.zero?
            :zero
          elsif n % 10 == 1 && n % 100 != 11
            # 1, 21, 31, 41, 51, 61...
            :one
          elsif [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100)
            # 2-4, 22-24, 32-34...
            :few
          elsif n % 10.zero? || ![5, 6, 7, 8, 9].include?(n % 10) || ![11, 12, 13, 14].include?(n % 100)
            # 0, 5-20, 25-30, 35-40...
            :many
          end
        end
      }
    }
  }
}
