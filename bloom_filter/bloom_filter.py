#coding: utf-8
import mmh3
from bitarray import bitarray

BIT_SIZE = 1 << 30

class BloomFilter:

    def __init__(self):
        # Initialize bloom filter, set size and all bits to 0
        bit_array = bitarray(BIT_SIZE)
        bit_array.setall(0)

        self.bit_array = bit_array

    def add(self, val):
        point_list = self.get_postions(val)

        for b in point_list:
            self.bit_array[b] = 1

    def get_postions(self, val):
        # Get points positions in bit vector.
        # 提供不同的hash种子得到多个hash函数, seed最好为质数

        point1 = mmh3.hash(val, 5)  % BIT_SIZE
        point2 = mmh3.hash(val, 7)  % BIT_SIZE
        point3 = mmh3.hash(val, 11) % BIT_SIZE
        point4 = mmh3.hash(val, 13) % BIT_SIZE
        point7 = mmh3.hash(val, 19) % BIT_SIZE
        point5 = mmh3.hash(val, 23) % BIT_SIZE
        point6 = mmh3.hash(val, 31) % BIT_SIZE

        return [point1, point2, point3, point4, point5, point6]

    def is_contains(self, val):
        point_list = self.get_postions(val)

        result = True
        for b in point_list:
            result = result and self.bit_array[b]

        return result


if __name__ == '__main__':

    bf = BloomFilter()

    # 第一次运行时会显示 not exists

    if bf.is_contains('zqw'):
        print('exists')
    else:
        print('not exists')
        bf.add('zqw')

    if bf.is_contains('shooter'):
        print('exists')
    else:
        bf.add('shooter')

    if bf.is_contains('zqw'):
        print('exists')
    else:
        bf.add('zqw')