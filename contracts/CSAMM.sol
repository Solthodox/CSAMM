// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;

contract CSAMM {
    address public inmutable token0;
    address public inmutable token1;

    mapping(uint256 => uint256) _reserves;

    uint256 public totalSupply;
    mapping(address => uint256) private _balances;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function swap(address _tokenIn, uint256 _amountIn)
        external
        returns (uint256 amountOut)
    {
        require(_tokenIn == token0 || _tokenOut == token1, "Invalid token");
        // transfer tokenIn to the contract
        uint256 amountIn;
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        amountIn =
            IERC20(_tokenIn).balanceOf(address(this)) -
            reserves[_tokenIn];
        // calculate amount out(including 0.3% fees)
        amountOut = (amountIn * 997) / 1000;
        address tokenOut = _tokenIn == token0 ? token1 : token0;
        // update reserves
        if (_tokenIn == token0) {
            _update(
                _reserves[token0] + _amountIn,
                _reserves[[token1] - amountOut]
            );
        } else {
            _update(
                _reserves[token1] + _amountIn,
                _reserves[[token0] - amountOut]
            );
        }
        // transfer token out
        IERC20(tokenOut).transfer(msg.sender, amountOut);
    }

    function addLiquidity(uint256 _amount0, uint256 _amount1)
        external
        returns (uint shares)
    {
        IERC20(token0).transferFrom(msg.sender, address(this), _amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), _amount1);

        uint256 bal0 = IERC20(token0).balanceOf(address(this));
        uint256 bal1 = IERC20(token1).balanceOf(address(this));

        uint256 d0 = bal0 - _reserves[token0];
        uint256 d1 = bal1 - _reserves[token1];

        shares = totalSupply == 0 ? d0 + d1 : ((d0 + d1) * totalSupply / (_reserves[token0] + _reserves[token1]) );
        assert(shares>0 , "Shares is equal to 0");
        _mint(msg.sender , shares);
        _update(bal0 , bal1);
    }

    function removeLiquidity(uint _shares) 
        external returns(uint d0 , uintd1)
    {
        d0 =( _reserves[token0] * _shares) / totalSuuply;
        d1 =( _reserves[token1] * _shares) / totalSuuply;
        _burn(msg.sender , _shares);
        _update(_reserves[token0] - d0 , _reserves[token1] - d1);

        if(d0 > 0){
            IERC20(token0).transfer(msg.sender , d0);
        }

        if(d1>0){
            IERC20(token1).transfer(msg.sender , d1);
        }
    }

    function _mint(address _to, uint256 _amount) private {
        _balances[_to] += _amount;
        _totalSupply += _amount;
    }

    function _burn(address _from, uint256 _amount) private {
        _balances[_from] -= _amount;
        _totalSupply -= _amount;
    }

    function _update(uint256 _res0, uint256 _res1) private {
        _reserves[token0] = _res0;
        _reserves[token1] = _res1;
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
