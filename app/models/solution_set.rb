class SolutionSet
  def initialize(mad_lib)
    @mad_lib = mad_lib
    @solutions = Array.new
  end

  def create
    solution = Solution.new(@mad_lib)
    @solutions.push solution
    solution
  end
end
