class Employee
  attr_accessor :manager
  attr_reader :name, :title, :salary

  def initialize(name, title, salary, multiplier = 0.2)
    @name = name
    @title = title
    @salary = salary
    @multiplier = multiplier
  end

  def bonus
    @salary * @multiplier
  end
end

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, multiplier = 0.3)
    super(name, title, salary, multiplier)
    @employees = []
  end

  def calculate_under_salary
    total_salaries = 0
    @employees.each do |employee|
      if employee.is_a?(Manager)
        total_salaries += employee.calculate_under_salary
      end

      total_salaries += employee.salary

    end
    total_salaries
  end

  def calculate_bonus
    (@salary + calculate_under_salary) * @multiplier
  end

  def bonus
    calculate_bonus
  end

  def add_employee(employee)
    employee.manager = self
    @employees << employee
  end
end

james = Employee.new("James", "Staffer", 50000)
boss = Manager.new("Bosser", "Boss", 60000)
more_boss = Manager.new("MoreBosser", "Super Boss", 70000)

more_boss.add_employee(boss)
boss.add_employee(james)
puts more_boss.bonus