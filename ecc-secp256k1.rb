# Bitcoin's curve - the secp256k1

Pcurve = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1 # Finite field, 有限域
# 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f

N = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 # 群的阶
Acurve = 0; Bcurve = 7 # 椭圆曲线的参数式. y^2 = x^3 + Acurve * x + Bcurve

Gx = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
Gy = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

GPoint = [Gx, Gy] # 椭圆曲线生成点, Base point.
#(Gx**3+7) % Pcurve == (Gy**2) % Pcurve, GPoint在椭圆曲线上, x/y坐标符合椭圆曲线方程

h = 1 # Subgroup cofactor, 子群辅因子为1, 就不参与运算了

# Pcurve, N, GPoint, secp256k1的函数式, 都是严格规定的, 严禁修改!!!

#私钥
privKey = 0xccea9c5a20e2b78c2e0fbdd8ae2d2b67e6b1894ccb7a55fc1de08bd53994ea64 # 取值小于群的阶,即 {0,N}

def inverse_mod(a, n=Pcurve) #Extended Euclidean Algorithm/'division' in elliptic curves
    # 扩展欧几里得算法, https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    lm, hm = 1,0
    low, high = a%n, n

    while low > 1
        ratio = high/low
        nm, new = hm-lm * ratio, high-low * ratio
        lm, low, hm, high = nm, new, lm, low
    end

    return lm % n
end

def ECadd(a, b) # 椭圆曲线加法
    lamAdd = ((b[1] - a[1]) * inverse_mod(b[0] - a[0], Pcurve) ) % Pcurve
    x = (lamAdd * lamAdd - a[0] - b[0]) % Pcurve
    y = (lamAdd * (a[0]-x) - a[1]) % Pcurve
    return [x,y]
end

def ECdouble(a) # 椭圆曲线倍乘
    lam = ((3 * a[0] * a[0] + Acurve) * inverse_mod( (2*a[1]), Pcurve)) % Pcurve
    x = (lam * lam - 2*a[0]) % Pcurve
    y = (lam * (a[0] - x) - a[1]) % Pcurve
    return [x,y]
end

def EccMultiply(genPoint, scalarHex) # Double & Add. Not true multiplication
    if scalarHex == 0 || scalarHex >= N
        raise Exception, "Invalid Scalar/Private Key"
    end

    scalarBin = scalarHex.to_s(2)

    q = genPoint

    endflag = scalarBin.size - 1

    (1..endflag).each do |i|
      q = ECdouble(q)

      if scalarBin[i] == "1"
        q = ECadd(q, genPoint)
      end

    end

    return q
end


puts; puts "******* 生成公钥 *********";
puts
PublicKey = EccMultiply(GPoint, privKey)
puts "私钥:";
puts privKey; puts
puts "未压缩公钥:";
puts PublicKey; puts
puts "未压缩公钥 (十六进制):";
puts "04" + PublicKey[0].to_s(16).rjust(64, "0") + PublicKey[1].to_s(16).rjust(64, "0")
puts;
puts "官方公钥 - 压缩的:";

if PublicKey[1] % 2 == 1 # If the Y value for the Public Key is odd.
    puts "03" + PublicKey[0].to_s(16).rjust(64, "0")
else # Or else, if the Y value is even.
    puts "02" + PublicKey[0].to_s(16).rjust(64, "0")
end

# "233".to_s.rjust(5, "0")  # => 00233