test.open('numbers.txt')
local assertEq = test.assertEq

assertEq(buffer:get_line(0), '123\n')
test.keys('1G0')
test.key('c-a')
assertEq(buffer:get_line(0), '124\n')
test.key('3', 'c-a')
assertEq(buffer:get_line(0), '127\n')
test.key('6', 'c-a')
assertEq(buffer:get_line(0), '133\n')

test.keys('2G0')
assertEq(buffer:get_line(1), '0x7f3\n')
test.key('c-a')
assertEq(buffer:get_line(1), '0x7f4\n')
test.key('1', '5', 'c-a')
assertEq(buffer:get_line(1), '0x803\n')
