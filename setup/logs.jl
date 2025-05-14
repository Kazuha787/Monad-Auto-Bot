#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]
  ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => su

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]
  ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
using Plots
using Random

# Parameters
width, height = 50, 50
generations = 100
grid = rand(0:1, height, width)

function count_neighbors(grid, x, y)
    sum([
        grid[mod1(x+i, size(grid, 1)), mod1(y+j, size(grid, 2))]
        for i in -1:1, j in -1:1 if !(i == 0 && j == 0)
    ])
end

function next_generation(grid)
    new_grid = similar(grid)
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            neighbors = count_neighbors(grid, i, j)
            if grid[i, j] == 1
                new_grid[i, j] = neighbors in (2, 3) ? 1 : 0
            else
                new_grid[i, j] = neighbors == 3 ? 1 : 0
            end
        end
    end
    return new_grid
end

# Animation setup
anim = @animate for gen = 1:generations
    heatmap(grid, c=:grays, title="Generation $gen", clims=(0, 1))
    global grid = next_generation(grid)
end

gif(anim, "game_of_life.gif", fps=10)
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
using Plots
using Random

# Parameters
width, height = 50, 50
generations = 100
grid = rand(0:1, height, width)

function count_neighbors(grid, x, y)
    sum([
        grid[mod1(x+i, size(grid, 1)), mod1(y+j, size(grid, 2))]
        for i in -1:1, j in -1:1 if !(i == 0 && j == 0)
    ])
end

function next_generation(grid)
    new_grid = similar(grid)
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            neighbors = count_neighbors(grid, i, j)
            if grid[i, j] == 1
                new_grid[i, j] = neighbors in (2, 3) ? 1 : 0
            else
                new_grid[i, j] = neighbors == 3 ? 1 : 0
            end
        end
    end
    return new_grid
end

# Animation setup
anim = @animate for gen = 1:generations
    heatmap(grid, c=:grays, title="Generation $gen", clims=(0, 1))
    global grid = next_generation(grid)
end

gif(anim, "game_of_life.gif", fps=10)
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show
    #= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
using Plots
using Random

# Parameters
width, height = 50, 50
generations = 100
grid = rand(0:1, height, width)

function count_neighbors(grid, x, y)
    sum([
        grid[mod1(x+i, size(grid, 1)), mod1(y+j, size(grid, 2))]
        for i in -1:1, j in -1:1 if !(i == 0 && j == 0)
    ])
end

function next_generation(grid)
    new_grid = similar(grid)
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            neighbors = count_neighbors(grid, i, j)
            if grid[i, j] == 1
                new_grid[i, j] = neighbors in (2, 3) ? 1 : 0
            else
                new_grid[i, j] = neighbors == 3 ? 1 : 0
            end
        end
    end
    return new_grid
end

# Animation setup
anim = @animate for gen = 1:generations
    heatmap(grid, c=:grays, title="Generation $gen", clims=(0, 1))
    global grid = next_generation(grid)
end

gif(anim, "game_of_life.gif", fps=10)
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
using Plots
using Random

# Parameters
width, height = 50, 50
generations = 100
grid = rand(0:1, height, width)

function count_neighbors(grid, x, y)
    sum([
        grid[mod1(x+i, size(grid, 1)), mod1(y+j, size(grid, 2))]
        for i in -1:1, j in -1:1 if !(i == 0 && j == 0)
    ])
end

function next_generation(grid)
    new_grid = similar(grid)
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            neighbors = count_neighbors(grid, i, j)
            if grid[i, j] == 1
                new_grid[i, j] = neighbors in (2, 3) ? 1 : 0
            else
                new_grid[i, j] = neighbors == 3 ? 1 : 0
            end
        end
    end
    return new_grid
end

# Animation setup
anim = @animate for gen = 1:generations
    heatmap(grid, c=:grays, title="Generation $gen", clims=(0, 1))
    global grid = next_generation(grid)
end

gif(anim, "game_of_life.gif", fps=10)
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
using Plots
using Random

# Parameters
width, height = 50, 50
generations = 100
grid = rand(0:1, height, width)

function count_neighbors(grid, x, y)
    sum([
        grid[mod1(x+i, size(grid, 1)), mod1(y+j, size(grid, 2))]
        for i in -1:1, j in -1:1 if !(i == 0 && j == 0)
    ])
end

function next_generation(grid)
    new_grid = similar(grid)
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            neighbors = count_neighbors(grid, i, j)
            if grid[i, j] == 1
                new_grid[i, j] = neighbors in (2, 3) ? 1 : 0
            else
                new_grid[i, j] = neighbors == 3 ? 1 : 0
            end
        end
    end
    return new_grid
end

# Animation setup
anim = @animate for gen = 1:generations
    heatmap(grid, c=:grays, title="Generation $gen", clims=(0, 1))
    global grid = next_generation(grid)
end

gif(anim, "game_of_life.gif", fps=10)
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
using Plots
using Random

# Parameters
width, height = 50, 50
generations = 100
grid = rand(0:1, height, width)

function count_neighbors(grid, x, y)
    sum([
        grid[mod1(x+i, size(grid, 1)), mod1(y+j, size(grid, 2))]
        for i in -1:1, j in -1:1 if !(i == 0 && j == 0)
    ])
end

function next_generation(grid)
    new_grid = similar(grid)
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            neighbors = count_neighbors(grid, i, j)
            if grid[i, j] == 1
                new_grid[i, j] = neighbors in (2, 3) ? 1 : 0
            else
                new_grid[i, j] = neighbors == 3 ? 1 : 0
            end
        end
    end
    return new_grid
end

# Animation setup
anim = @animate for gen = 1:generations
    heatmap(grid, c=:grays, title="Generation $gen", clims=(0, 1))
    global grid = next_generation(grid)
end

gif(anim, "game_of_life.gif", fps=10)
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
#= 
  Mini Data Analysis Project in Julia
  Dataset: Mock Sales Data
  By: Kazuha’s Evil Twin
=#

using CSV
using DataFrames
using Plots
using Dates
using Statistics
using Printf

# Constants
const DATA_PATH = "sales_data.csv"

# ==== Section 1: Generate Fake Data (if not exists) ====
if !isfile(DATA_PATH)
    println("Generating fake data...")
    names = ["Alice", "Bob", "Charlie", "Diana"]
    regions = ["North", "South", "East", "West"]
    products = ["Widget", "Gadget", "Thingy", "Doohickey"]
using HTTP
using Gumbo
using CSV
using DataFrames

# Function to fetch and parse HTML from a URL
function fetch_html(url::String)
    try
        # Send a GET request to the website
        response = HTTP.get(url)
        
        if response.status != 200
            error("Failed to fetch URL: $url with status code $(response.status)")
        end
        
        return String(response.body)
    catch e
        println("Error fetching the webpage: ", e)
        return ""
    end
end

# Function to scrape all links on the page (as an example)
function scrape_links(parsed_html)
    # Find all anchor <a> tags in the parsed HTML
    links = []
    for element in eachmatch(r"<a[^>]+href=\"([^\"]+)\"", parsed_html)
        push!(links, element.match[1])  # Extract the URL from the href attribute
    end
    return links
end

# Function to scrape headings (<h1>, <h2>, <h3>, etc.) from the page
function scrape_headings(parsed_html)
    headings = Dict()
    for h_tag in 1:6  # For h1, h2, ..., h6
        tag_name = "h" * string(h_tag)
        headings[tag_name] = []
        
        for element in eachmatch(r"<$tag_name[^>]*>(.*?)</$tag_name>", parsed_html)
            push!(headings[tag_name], strip(element.match[1]))  # Extract and clean the text
        end
    end
    return headings
end

# Function to extract text from all <p> tags (paragraphs)
function scrape_paragraphs(parsed_html)
    paragraphs = []
    for element in eachmatch(r"<p[^>]*>(.*?)</p>", parsed_html)
        push!(paragraphs, strip(element.match[1]))  # Extract the text inside <p> tags
    end
    return paragraphs
end

# Function to parse and process the HTML
function parse_html(url::String)
    html_content = fetch_html(url)
    
    if html_content == ""
        return
    end
    
    # Parse the HTML content using Gumbo
    parsed_html = parsehtml(html_content)

    # Scrape links, headings, and paragraphs
    links = scrape_links(html_content)
    headings = scrape_headings(html_content)
    paragraphs = scrape_paragraphs(html_content)
    
    # Store the results in a DataFrame
    data = DataFrame(
        Heading1 = headings["h1"],
        Heading2 = headings["h2"],
        Paragraph = paragraphs
    )
    
    # Print out the scraped content (optional)
    println("Links found on the page:")
    println(links)

    println("\nHeadings found on the page:")
    for (key, value) in headings
        println("$key: $value")
    end

    println("\nParagraphs found on the page:")
    println(paragraphs)

    # Save the data to a CSV file
    CSV.write("scraped_data.csv", data)
    
    println("\nScraped data has been saved to 'scraped_data.csv'.")
end

# Example usage
url = "https://example.com"  # Change this to any webpage you want to scrape
parse_html(url)

    df = DataFrame(Date=Date[], Name=String[], Region=String[], Product=String[], Quantity=Int[], Price=Float64[])
    for i in 1:1000
        date = Date(2024,1,1) + Day(rand(0:364))
        name = rand(names)
        region = rand(regions)
        product = rand(products)
        quantity = rand(1:10)
        price = round(rand(10.0:0.5:100.0), digits=2)
        push!(df, (date, name, region, product, quantity, price))
    end
    CSV.write(DATA_PATH, df)
    println("Fake data saved to $DATA_PATH")
end

# ==== Section 2: Load and Inspect ====
println("\nLoading data...")
data = CSV.read(DATA_PATH, DataFrame)
println("First 5 rows:")
show(data[1:5, :])

# ==== Section 3: Clean Data ====
function clean_data(df::DataFrame)
    df = dropmissing(df)
    df = filter(row -> row.Quantity > 0 && row.Price > 0.0, df)
    return df
end

data = clean_data(data)

# ==== Section 4: Analysis ====

# Total sales column
data.Sales = data.Quantity .* data.Price

# Daily totals
daily_sales = combine(groupby(data, :Date), :Sales => sum => :TotalSales)

# Top products
product_sales = combine(groupby(data, :Product), :Sales => sum => :TotalSales)
sort!(product_sales, :TotalSales, rev=true)

# Top regions
region_sales = combine(groupby(data, :Region), :Sales => sum => :TotalSales)
sort!(region_sales, :TotalSales, rev=true)

# ==== Section 5: Custom Types and Functions ====

struct SummaryStats
    total_revenue::Float64
    avg_daily_sales::Float64
    best_product::String
    best_region::String
end

function summarize(df::DataFrame)::SummaryStats
    total_revenue = sum(df.Sales)
    avg_daily = mean(daily_sales.TotalSales)
    best_product = product_sales.Product[1]
    best_region = region_sales.Region[1]
    return SummaryStats(total_revenue, avg_daily, best_product, best_region)
end

summary = summarize(data)
println("\nSummary:")
@printf "Total Revenue: \$%.2f\n" summary.total_revenue
@printf "Average Daily Sales: \$%.2f\n" summary.avg_daily_sales
println("Top Product: $(summary.best_product)")
println("Top Region: $(summary.best_region)")

# ==== Section 6: Plotting ====
default(size=(900, 500), legend=:topleft)

p1 = plot(daily_sales.Date, daily_sales.TotalSales, title="Daily Sales", xlabel="Date", ylabel="Revenue", lw=2)
p2 = bar(product_sales.Product, product_sales.TotalSales, title="Sales by Product", xlabel="Product", ylabel="Revenue")
p3 = pie(region_sales.Region, region_sales.TotalSales, title="Region Share")

plot(p1, p2, p3, layout=(3,1))
savefig("sales_report.png")
println("\nPlots saved as 'sales_report.png'")

# ==== Section 7: Mini CLI ====

function cli()
    println("\n--- MINI CLI ---")
    println("1. Show summary")
    println("2. Show top 5 products")
    println("3. Show top 5 regions")
    println("4. Exit")
    while true
        print("\nEnter choice: ")
        choice = readline()
        if choice == "1"
            println("Total Revenue: \$$(round(summary.total_revenue, digits=2))")
        elseif choice == "2"
            show(product_sales[1:5, :])
        elseif choice == "3"
            show(region_sales[1:5, :])
        elseif choice == "4"
            println("Bye!")
            break
        else
            println("Invalid choice.")
        end
    end
end

cli()
