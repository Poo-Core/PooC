-- Define the Matrix class
Matrix = Class()
--[[
    Matrix
]]

-- Constructor
function Matrix:__init(rows, cols)
    self._data = {}
    self._rows = rows
    self._cols = cols
    for i = 1, rows do
        self._data[i] = {}
        for j = 1, cols do
            self._data[i][j] = 0
        end
    end
end

-- Get the number of rows in the matrix
function Matrix:getRows()
    return self._rows
end

-- Get the number of columns in the matrix
function Matrix:getCols()
    return self._cols
end

-- Get the value at a specific row and column in the matrix
function Matrix:getValue(row, col)
    return self._data[row][col]
end

-- Set the value at a specific row and column in the matrix
function Matrix:setValue(row, col, value)
    self._data[row][col] = value
end

-- Transpose the matrix
function Matrix:transpose()
    local transposedMatrix = Matrix(self._cols, self._rows)
    for i = 1, self._rows do
        for j = 1, self._cols do
            transposedMatrix:setValue(j, i, self._data[i][j])
        end
    end
    return transposedMatrix
end
