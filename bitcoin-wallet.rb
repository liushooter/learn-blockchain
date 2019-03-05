require 'digest'

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


PublicKey = EccMultiply(GPoint, privKey)
_pub_key = "04" + PublicKey[0].to_s(16).rjust(64, "0") + PublicKey[1].to_s(16).rjust(64, "0")

_compressed_pub_key = if PublicKey[1] % 2 == 1 # If the Y value for the Public Key is odd.
  "03" + PublicKey[0].to_s(16).rjust(64, "0")
else # Or else, if the Y value is even.
  "02" + PublicKey[0].to_s(16).rjust(64, "0")
end


puts
puts "########### 生成公钥 ##########"
puts
puts "私钥:";
puts privKey
puts "未压缩公钥:"
puts PublicKey; puts
puts "未压缩公钥 (十六进制):";
puts _pub_key
puts;
puts "官方公钥 - 压缩的:";
puts _compressed_pub_key

######################gen bitcoin addr############################

_P2PKH = "00"
_P2SH = "05"
_Testnet = "6F"

def _hash160(pub_key)
  bytes = [pub_key].pack("H*") # 转为16进制
  Digest::RMD160.hexdigest(Digest::SHA256.digest(bytes) )
end

def _checksum(val)
  hex_str = [val].pack("H*")
  Digest::SHA256.hexdigest(Digest::SHA256.digest(hex_str) )[0...8]
end

def _encode_base58(int_val, leading_zero_bytes=0)
  alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  base58_val, base = '', alpha.size

  while int_val > 0
    int_val, remainder = int_val.divmod(base)
    base58_val = alpha[remainder] + base58_val
  end

  base58_val
end

def gen_addr(prefix, pub)
  hash160 = _hash160(pub)
  tmp = prefix + hash160
  checksum = _checksum(tmp)
  val = tmp+checksum

  leading_zero_bytes = (val.match(/^([0]+)/) ? $1 : '').size / 2
  ("1" * leading_zero_bytes) + _encode_base58(val.to_i(16) )
end

puts "########### 生成地址 ##########"

puts gen_addr(_P2PKH, _pub_key)
puts gen_addr(_P2SH, _pub_key)
puts gen_addr(_Testnet, _pub_key)
puts

puts "现在一般都使用压缩公钥", "非压缩公钥早已成了非主流", "压缩/未压缩公钥生成的地址确实不一样"
puts gen_addr(_P2PKH, _compressed_pub_key)
puts gen_addr(_P2SH, _compressed_pub_key)
puts gen_addr(_Testnet, _compressed_pub_key)
puts

######################gen bitcoin addr############################


######################WIF: Wallet Import Format############################

_wif_mainnet = '80'
_wif_testnet = 'ef'

_pri_key = privKey.to_s(16)

def _base58_to_int(base58_val)
    alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

    size = alphabet.size

    int_val = 0
    base58_val.reverse.split(//).each_with_index do |char,index|
      char_index = alphabet.index(char)
      int_val += (char_index)*(size**(index))
    end
    int_val
  end


def _int_to_hex val
  hex = val.to_s(16)
  (hex.length % 2 == 0) ? hex : ('0'+hex)
end

def _decode_base58(base58_val)
  alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

  nzeroes = base58_val.chars.find_index{|c| c != alphabet[0]} || base58_val.length-1
  prefix = nzeroes < 0 ? '' : '00' * nzeroes

  nzeroes = base58_val.chars.find_index{|c| c != alphabet} || base58_val.length-1
  prefix = nzeroes < 0 ? '' : '00' * nzeroes
  prefix + _int_to_hex(_base58_to_int(base58_val))
end


def pri_key_to_wif(prefix, pri, compress=true)
  flag = compress ? "01" : ""
  rk = prefix + pri + flag
  hash160 = _hash160(rk)
  checksum = _checksum(rk)
  val = rk + checksum

  _encode_base58(val.to_i(16))
end


def wif_to_pri_key(wif_addr)
  pri_key = ""
  _val = _decode_base58(wif_addr)

  if wif_addr.size == 52
      pri_key = _val[2..-11]
  end

 if wif_addr.size == 51
      pri_key = _val[2..-9]
  end

  pri_key
end

puts "########### 生成WIF格式公私钥 ##########"

puts "WIF: Wallet Import Format"
puts "非压缩私钥的WIF格式是51位长度, 已5开头"
puts "压缩私钥的WIF格式是52位长度, 已K或L开头"

puts

puts "WIF 非压缩私钥:", pri_key_to_wif(_wif_mainnet, _pri_key, false)
res = pri_key_to_wif(_wif_mainnet, _pri_key)
puts "WIF 压缩私钥:", res
puts "WIF格式转换为普通格式:", wif_to_pri_key(res)
puts

######################WIF: Wallet Import Format############################
