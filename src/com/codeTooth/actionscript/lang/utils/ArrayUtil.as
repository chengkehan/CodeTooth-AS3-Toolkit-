package com.codeTooth.actionscript.lang.utils
{	
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.IndexOutOfBoundsException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * 数组助手ArrayUtil 。
	 */	
	
	public class ArrayUtil
	{
		/**
		 * 创建指定数组的一个副本
		 * 
		 * @param	arr
		 * 
		 * @return 
		 */
		public static function copyArray(arr:Array):Array
		{
			return arr == null ? null : arr.concat();
		}
		
		/**
		 * 创建指定 vector 的一个副本
		 * 
		 * @param	v
		 * 
		 * @return
		 */
		public static function copyVector(v:Object):*
		{
			if (v == null)
			{
				return null;
			}
			else
			{
				return v.concat();
			}
		}
		
		/**
		 * 连接两个数组
		 * 
		 * @param	arr1
		 * @param	arr2
		 * 
		 * @return
		 */
		public static function concatArray(arr1:Array, arr2:Array):Array
		{
			if (arr1 != null && arr2 != null)
			{
				return arr1.concat(arr2);
			}
			else if (arr1 == null && arr2 == null)
			{
				return null;
			}
			else if (arr1 != null)
			{
				return arr1.concat();
			}
			// else if(arr2 != null)
			else
			{
				return arr2.concat();
			}
		}
		
		/**
		 * 连接两个 vector
		 * 
		 * @param	v1
		 * @param	v2
		 * 
		 * @return
		 */
		public static function concatVector(v1:Object, v2:Object):*
		{
			if (v1 != null && v2 != null)
			{
				return v1.concat(v2);
			}
			else if (v1 == null && v2 == null)
			{
				return null;
			}
			else if (v1 != null)
			{
				return v1.concat();
			}
			// else if(v2 != null)
			else
			{
				return v2.concat();
			}
		}
		
		/**
		 * 获得一个数组，每个项是map对象的每个值对象。
		 * 获得的值数组不保证顺序。
		 * 
		 * @param map	指定的map对象。
		 * 
		 * @return	 返回一个数组，数组中的每一项是map的值。如果入参是null，则返回null。
		 */		
		public static function getValuesArrayOfMap(map:Object):Array
		{
			if (map != null)
			{
				var array:Array = new Array();
				for each(var item:Object in map)
				{
					array.push(item);
				}
				
				return array;
			}
			else
			{
				return null;
			}	
		}
		
		/**
		 * 获得一个数组，每个项是map对象的每个键对象。
		 * 获得的键数组不保证顺序
		 * 
		 * @param map 指定的map对象
		 * 
		 * @return 返回一个数组，每一项是map对象的键对象。如果入参是null，则返回null。
		 */		
		public static function getKeysArrayOfMap(map:Object):Array
		{
			if (map != null)
			{
				var array:Array = new Array();
				for(var pName:Object in map)
				{
					array.push(pName);
				}
				
				return array;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 获得map对象的值迭代器。
		 * 获得的值迭代器的不保证顺序。
		 * 
		 * @param map 指定的map对象。
		 * 
		 * @return 返回map对象的值迭代器。如果入参是null，则返回null。
		 */		
		public static function getValuesIteratorOfMap(map:Object):IIterator
		{
			return map == null ? null : new ArrayIterator(getValuesArrayOfMap(map));
		}
		
		/**
		 * 获得map对象的键迭代器。
		 * 获得的键迭代器的不保证顺序。
		 * 
		 * @param map 指定的map对象
		 * 
		 * @return 返回map对象的键迭代器。如果入参是null，则返回null
		 */
		public static function getKeysIteratorOfMap(map:Object):IIterator
		{
			return map == null ? null : new ArrayIterator(getKeysArrayOfMap(map));
		}
		
		/**
		 * 数组转换成 Vector
		 * 
		 * @param	array
		 * 
		 * @return
		 */
		public static function arrayToVector(array:Array):*
		{
			if (array == null)
			{
				return null;
			}
			else
			{
				var length:int = array.length;
				var v:Vector.<Object> = new Vector.<Object>(length);
				for (var i:int = 0; i < length; i++)
				{
					v[i] = array[i];
				}
				
				return v;
			}
		}
		
		/**
		 * Vector 转换成数组
		 * 
		 * @param	v
		 * 
		 * @return
		 */
		public static function vectorToArray(v:Object):Array
		{
			if (v == null)
			{
				return null;
			}
			else
			{
				var length:int = v.length;
				var array:Array = new Array(length);
				for (var i:int = 0; i < length; i++)
				{
					array[i] = v[i];
				}
				
				return array;
			}
		}
		
		/**
		 * 在一个一维的集合中通过行列这样的二维参数找到指定的元素
		 * 
		 * @param	collection 指定的一维集合。可以是Vector或者Array
		 * @param	rows 总行数
		 * @param	cols 总列数
		 * @param	row 指定的行，从0开始
		 * @param	col 指定的列，从0开始
		 * 
		 * @return	返回要找的元素。
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IndexOutOfBoundsException 
		 * 指定的行列索引超出了范围
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的集合是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定的row超过了rows或者指定的col超过了cols
		 */
		public static function getItemByRowCol(collection:Object, row:uint, col:uint, rows:uint, cols:uint):*
		{
			if(collection == null)
			{
				throw new NullPointerException("Null collection");
			}
			if(row >= rows)
			{
				throw new IllegalParameterException("Row index \"" + row +　"\" cannot >= rows \"" + rows + "\"");
			}
			if(col >= cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + cols + "\"");
			}
			
			var index:uint = cols * row + col;
			if(index >= rows * cols)
			{
				throw new IndexOutOfBoundsException("Index \"" + index + "\" out of bounds \"" + (rows * cols) + "\"");
			}
			
			return collection[index];
		}
		
		/**
		 * 在一个一维的集合中通过行列这样的二维参数设定元素
		 * 
		 * @param collection	一维集合。可以是Vector或者是Array
		 * @param value	要设定的值
		 * @param row	设定的值所在的行
		 * @param col	设定的值所在的列
		 * @param rows	模拟的行总数
		 * @param cols	模拟的列总数
		 */
		public static function setItemByRowCol(collection:Object, value:Object, row:uint, col:uint, rows:uint, cols:uint):void
		{
			if(collection)
			{
				throw new NullPointerException("Null collection");
			}
			if(row >= rows)
			{
				throw new IllegalParameterException("Row index \"" + row +　"\" cannot >= rows \"" + rows + "\"");
			}
			if(col >= cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + cols + "\"");
			}
			
			var index:uint = row * cols + col;
			if(index >= rows * cols)
			{
				throw new IndexOutOfBoundsException("Index \"" + index + "\" out of bounds \"" + (rows * cols) + "\"");
			}
			
			collection[index] = value;
		}
		
		/**
		 * 通过二维的行列参数，获得对应一维的索引值
		 * 
		 * @param row
		 * @param col
		 * @param rows
		 * @param cols
		 * 
		 * @return 返回得到的索引值。失败返回-1
		 */
		public static function getIndexByRowCol(row:uint, col:uint, rows:uint, cols:uint):uint
		{
			if(row >= rows)
			{
				throw new IllegalParameterException("Row index \"" + row +　"\" cannot >= rows \"" + rows + "\"");
			}
			if(col >= cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + cols + "\"");
			}
			
			return row * cols + col;
		}
		
		/**
		 * 在一个一维集合中找到属性值和指定值相等的元素
		 * 
		 * @param	collection 一维集合。可以是Vector或Array或键值对
		 * @param	propName 指定的属性名称
		 * @param	equalValue 指定的比较值
		 * 
		 * @return 返回找到的元素。如果没有找到返回null
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的集合是null
		 */
		public static function getItemByProperty(collection:Object, propName:String, equalValue:Object):*
		{
			if(collection == null)
			{
				throw new NullPointerException("Null collection");
			}
			
			for each(var item:Object in collection)
			{
				if (item != null)
				{
					if (item[propName] == equalValue)
					{
						return item;
					}
				}
			}
			
			return null;
		}
		
		/**
		 * 在一个一维集合中找到方法返回值和指定值相等的元素
		 * 
		 * @param	collection 一维集合。可以是Vector或Array或键值对
		 * @param	methodName 方法的名称
		 * @param	equalValue 指定的和方法返回值进行比较的值
		 * @param	getMethodArgs 获得的方法的入参。null表示方法没有入参。func(item:Object):Array
		 * 
		 * @return	返回找到的元素。没有找到返回null
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的集合是null
		 */
		public static function getItemByMethodReturnValue(collection:Object, methodName:String, equalValue:Object, getMethodArgs:Function = null):*
		{
			if(collection == null)
			{
				throw new NullPointerException("Null collection");
			}
			
			for each(var item:Object in collection)
			{
				if (item != null)
				{
					if (getMethodArgs == null)
					{
						if (item[methodName]() == equalValue)
						{
							return item;
						}
					}
					else
					{
						if (item[methodName].apply(item, getMethodArgs(item)) == equalValue)
						{
							return item;
						}
					}
				}
			}
			
			return null;
		}
	}
}