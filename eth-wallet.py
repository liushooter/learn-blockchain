#coding:utf-8
import sha3
import binascii

# Super simple Elliptic Curve Presentation. No imported libraries, wrappers, nothing.
# For educational purposes only. Remember to use Python 2.7.6 or lower.
# You'll need to make changes for Python 3.

# Below are the public specs for Bitcoin's curve - the secp256k1

Pcurve = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 -1 # Finite field, 有限域
# 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f

N = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 # 群的阶
Acurve = 0; Bcurve = 7 # 椭圆曲线的参数式. y^2 = x^3 + Acurve * x + Bcurve

Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240
# 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798

Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424
# 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

GPoint = (Gx, Gy) # 椭圆曲线生成点, Base point.
#(Gx**3+7) % Pcurve == (Gy**2) % Pcurve, GPoint在椭圆曲线上, x/y坐标符合椭圆曲线方程

h = 1 # Subgroup cofactor, 子群辅因子为1, 就不参与运算了

# Pcurve, N, GPoint, secp256k1的函数式, 都是严格规定的, 严禁修改!!!

#私钥
# privKey =  # 取值小于群的阶,即 {0,N}

def inverse_mod(a, n=Pcurve): #Extended Euclidean Algorithm/'division' in elliptic curves
    # 扩展欧几里得算法, https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    lm, hm = 1,0
    low, high = a%n,n
    while low > 1:
        ratio = high/low
        nm, new = hm-lm*ratio, high-low*ratio
        lm, low, hm, high = nm, new, lm, low
    return lm % n

def ECadd(a, b): # 椭圆曲线加法
    LamAdd = ((b[1]-a[1]) * inverse_mod(b[0]-a[0],Pcurve) ) % Pcurve
    x = (LamAdd*LamAdd-a[0]-b[0]) % Pcurve
    y = (LamAdd*(a[0]-x)-a[1]) % Pcurve
    return (x,y)

def ECdouble(a): # 椭圆曲线倍乘
    Lam = ((3*a[0]*a[0]+Acurve) * inverse_mod((2*a[1]) ,Pcurve) ) % Pcurve
    x = (Lam*Lam-2*a[0]) % Pcurve
    y = (Lam*(a[0]-x)-a[1]) % Pcurve
    return (x,y)

def EccMultiply(GenPoint, ScalarHex): # Double & Add. Not true multiplication
    if ScalarHex == 0 or ScalarHex >= N: raise Exception("Invalid Scalar/Private Key")

    ScalarBin = str(bin(ScalarHex))[2:]

    Q=GenPoint
    for i in range (1, len(ScalarBin)): # EC乘法转为标量乘法进行计算, 能减少运算量
        Q=ECdouble(Q);

        if ScalarBin[i] == "1":
            Q=ECadd(Q,GenPoint); # print "ADD", Q[0]; print

    return (Q)

def gen_eth_addr(privKey):
  print; print "******* 生成公钥 *********";
  print
  PublicKey = EccMultiply(GPoint, privKey)

  uncompression = "04" + "%064x" % PublicKey[0] + "%064x" % PublicKey[1];

  print "私钥:";
  print privKey; print
  print "未压缩公钥 (不是地址):";
  print PublicKey; print
  print "未压缩公钥 (十六进制):";
  print uncompression;
  print;
  print "官方公钥 - 压缩的:";

  _pub_key = ""
  if PublicKey[1] % 2 == 1: # If the Y value for the Public Key is odd.
      _pub_key = "03"+str(hex(PublicKey[0])[2:-1]).zfill(64)
  else: # Or else, if the Y value is even.
      _pub_key = "02"+str(hex(PublicKey[0])[2:-1]).zfill(64)

  print(_pub_key)

  _pub_hex = binascii.unhexlify(uncompression[2:]) #  eth生成地址不用压缩公钥

  keccak = sha3.keccak_256()
  keccak.update(_pub_hex)

  address = "0x" + keccak.hexdigest()[24:]

  print("eth地址")
  print address
  print "-"*100

if __name__ == "__main__":
    gen_eth_addr(0x3bad8b7494ea2a23c603c171d29bcfb83595c0497522d42c35bcbcae53201946)
    gen_eth_addr(0x8D03956D15969EF9E945CCF5C1973951E03F921E7E4414B3E685A1CFF9398842)
    gen_eth_addr(0x4455ecbf099803ffa14f3317791ef42b0bbaf6b52735ff2ce9460494979ad976)