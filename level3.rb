require "date"

class Todo
  def initialize(text, due_date, completed)
    @text = text
    @due_date = due_date
    @completed = completed
  end

  def overdue?
    @due_date < Date.today # Here I cheak wheather the date is less than the due date .
  end

  def due_today?
    @due_date == Date.today # Here I cheak wheather the date is equal the due date .
  end

  def due_later?
    @due_date > Date.today # Here I cheak wheather the date is grater than the due date .
  end

  def to_displayable_string
    todo_status = @completed ? "[X]" : "[ ]" # Here I cheak wheather the todo_status is true or false.
    todo_date = @due_date == Date.today ? nil : @due_date

    "#{todo_status} #{@text} #{todo_date}"
  end
end

class TodosList
  def initialize(todos)
    @todos = todos
  end

  def overdue
    TodosList.new(@todos.filter { |todo| todo.overdue? })
  end

  def due_today
    TodosList.new(@todos.filter { |todo| todo.due_today? })
  end

  def due_later
    TodosList.new(@todos.filter { |todo| todo.due_later? })
  end

  def add(new_Todo)
    @todos.push(new_Todo)  # Here I gave a new entry of todos.
  end

  def to_displayable_list
    @todos.map { |todo| todo.to_displayable_string }.join("\n")
  end
end

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

todos = todos.map { |todo|
  Todo.new(todo[:text], todo[:due_date], todo[:completed])
}

todos_list = TodosList.new(todos)

todos_list.add(Todo.new("Service vehicle", date, false))

puts "My Todo-list\n\n"

puts "Overdue\n"
puts todos_list.overdue.to_displayable_list
puts "\n\n"

puts "Due Today\n"
puts todos_list.due_today.to_displayable_list
puts "\n\n"

puts "Due Later\n"
puts todos_list.due_later.to_displayable_list
puts "\n\n"
