package com.codeTooth.actionscript.lang.utils 
{
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	import com.codeTooth.actionscript.reflect.core.Accessor;
	import com.codeTooth.actionscript.reflect.core.Constant;
	import com.codeTooth.actionscript.reflect.core.Constructor;
	import com.codeTooth.actionscript.reflect.core.Method;
	import com.codeTooth.actionscript.reflect.core.Parameter;
	import com.codeTooth.actionscript.reflect.core.Reflect;
	import com.codeTooth.actionscript.reflect.core.ReflectObject;
	import com.codeTooth.actionscript.reflect.core.Variable;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 调试使用。
	 */
	public class Debug
	{
		//----------------------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 用字符串表达一个动态对象的结构
		 * 
		 * @param obj
		 * 
		 * @return 
		 */
		public static function dynamicObjectToString(obj:Object):String
		{
			if(obj == null)
			{
				return "null";
			}
			else
			{
				var str:String = obj.toString() + Common.NEW_LINE;
				return dynamicObjectToStringRecursion(obj, str, Common.TAB);
			}
		}
		
		private static function dynamicObjectToStringRecursion(obj:Object, str:String, tab:String):String
		{
			for (var pName:Object in obj)
			{
				var qualifiedClassName:String = getQualifiedClassName(obj[pName]);
				
				if (qualifiedClassName == "Object" || 
					qualifiedClassName == "Array" || 
					qualifiedClassName == "flash.utils::Dictionary" || 
					qualifiedClassName.indexOf("Vector.<") != -1 || 
					qualifiedClassName == "mx.collections.ArrayCollection")
				{
					str += tab + pName + "=" + qualifiedClassName + Common.NEW_LINE;
					str = dynamicObjectToStringRecursion(obj[pName], str, tab + Common.TAB);
				}
				else
				{
					str += tab + pName + "=" + obj[pName] + Common.NEW_LINE;
				}
			}
			
			return str;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		//----------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 打印一个动态对象。
		 * 
		 * @param	object 打印的对象
		 * @param	title 打印的标题
		 */
		public static function printDynamicObject(object:Object, title:String = ""):void
		{
			trace("----------------------------------------------------------------------------------------");
			trace("Debug : " + title);
			trace(object);
			printDynamicObjectRecursion(object, Common.TAB);
			trace("----------------------------------------------------------------------------------------");
		}
		
		// 递归的打印对象
		private static function printDynamicObjectRecursion(object:Object, tab:String):void
		{
			var qualifiedClassName:String;
			
			for (var pName:Object in object)
			{
				qualifiedClassName = getQualifiedClassName(object[pName]);
				
				if (qualifiedClassName == "Object" || 
					qualifiedClassName == "Array" || 
					qualifiedClassName == "flash.utils::Dictionary" || 
					qualifiedClassName.indexOf("Vector.<") != -1)
				{
					trace(tab + pName + "=" + qualifiedClassName);
					printDynamicObjectRecursion(object[pName], tab + Common.TAB);
				}
				else
				{
					trace(tab + pName + "=" + object[pName]);
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		//----------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 普通内容
		 */
		public static const NORMAL:int = 1;
		
		/**
		 * 继承内容
		 */
		public static const EXTENDS:int = 2;
		
		/**
		 * 接口实现内容
		 */
		public static const IMPLEMENTS:int = 4;
		
		/**
		 * 构造函数内容
		 */
		public static const CONSTRUCTOR:int = 8;
		
		/**
		 * 静态常量内容
		 */
		public static const STATIC_CONSTANTS:int = 16;
		
		/**
		 * 静态存取器内容
		 */
		public static const STATIC_ACCESSORS:int = 32;
		
		/**
		 * 静态方法内容
		 */
		public static const STATIC_METHODS:int = 64;
		
		/**
		 * 静态变量内容
		 */
		public static const STATIC_VARIABLES:int = 128;
		
		/**
		 * 常量内容
		 */
		public static const CONSTANTS:int = 256;
		
		/**
		 * 存取器内容
		 */
		public static const ACCESSORS:int = 512;
		
		/**
		 * 方法内容
		 */
		public static const METHODS:int = 1024;
		
		/**
		 * 变量内容
		 */
		public static const VARIABLES:int = 2048;
		
		/**
		 * 使用反射来打印对象的所有属性和方法信息。
		 * 
		 * @param	object 打印的对象
		 * @param content 打印的内容，传入0表示打印全部。
		 * @param title 打印的标题
		 * 
		 * @example
		 * // 打印Sprite所有的继承和接口
		 * printObject(Sprite, Debug.EXTENDS | Debug.IMPLEMENTS);
		 */
		public static function printObject(object:Object, content:int = 0, title:String = ""):void
		{
			Reflect.setObject(object);
			var refObj:ReflectObject = Reflect.getReflectObject();
			
			trace("----------------------------------------------------------------------------------------");
			trace("Debug : " + title);
			trace(object);
			
			if (content == 0 || content & NORMAL)
			{
				trace("Type:" + refObj.type);
				trace("Definition:" + refObj.definition);
				trace("BaseType:" + refObj.baseType);
				trace("BaseDefinition:" + refObj.baseDefinition);
				trace("IsDynamic:" + refObj.isDynamic);
				trace("IsFinal:" + refObj.isFinal);
				trace("IsStatic:" + refObj.isStatic);
			}
			
			if (content == 0 || content & EXTENDS)
			{
				trace("Extends:");
				var extds:IIterator = refObj.extendsTypesIterator();
				if (extds == null)
				{
					trace("\tnone");
				}
				else
				{
					while (extds.hasNext())
					{
						trace(Common.TAB + extds.next());
					}
					extds.destroy();
				}
			}
			
			if (content == 0 || content & IMPLEMENTS)
			{
				trace("Implements");
				var impls:IIterator = refObj.implementsTypesIterator();
				if (impls == null)
				{
					trace("\tnone");
				}
				else
				{
					while (impls.hasNext())
					{
						trace(Common.TAB + impls.next());
					}
					impls.destroy();
				}
			}
			
			if (content == 0 || content & CONSTRUCTOR)
			{
				trace("Constructor");
				trace("\tParameters");
				var constructor:Constructor = refObj.constructor;
				var constructorParams:IIterator = constructor.parametersIterator();
				var constructorParam:Parameter;
				if (constructorParams == null)
				{
					trace("\t\tnone");
				}
				else
				{
					while (constructorParams.hasNext())
					{
						constructorParam = constructorParams.next();
						trace("\t\tParameter");
						trace("\t\t\tIndex:" + constructorParam.index);
						trace("\t\t\tType:" + constructorParam.type);
						trace("\t\t\tDefinition:" + constructorParam.definition);
						trace("\t\t\tOptional:" + constructorParam.optional);
					}
					constructorParams.destroy();
				}
			}
			
			if (content == 0 || content & STATIC_CONSTANTS)
			{
				trace("StaticConstants");
				var staticConstants:IIterator = refObj.staticConstantsIterator();
				var staticConstant:Constant;
				if (staticConstants != null)
				{
					while (staticConstants.hasNext())
					{
						staticConstant = staticConstants.next();
						trace("\tStaticConstant");
						trace("\t\tName:" + staticConstant.name);
						trace("\t\tType:" + staticConstant.type);
						trace("\t\tDefinition:" + staticConstant.definition);
					}
					staticConstants.destroy();
				}
				else
				{
					trace("\tnone");
				}
			}
			
			if (content == 0 || content & STATIC_ACCESSORS)
			{
				trace("StaticAccessors");
				var staticAccessors:IIterator = refObj.staticAccessorsIterator();
				var staticAccessor:Accessor;
				if(staticAccessors == null)
				{
					trace("\tnone");
				}
				else
				{
					while (staticAccessors.hasNext())
					{
						staticAccessor = staticAccessors.next();
						trace("\tStaticAccessor");
						trace("\t\tName:" + staticAccessor.name);
						trace("\t\tAccess:" + staticAccessor.access);
						trace("\t\tType:" + staticAccessor.type);
						trace("\t\tDefinition:" + staticAccessor.definition);
						trace("\t\tDeclaredByType:" + staticAccessor.declaredByType);
						trace("\t\tDeclaredByDefinition:" + staticAccessor.declaredByDefinition);
					}
				}
			}
			
			if (content == 0 || content & STATIC_METHODS)
			{
				trace("StaticMethods");
				var staticMethods:IIterator = refObj.staticMethodsIterator();
				var staticMethod:Method;
				var staticMethodParameters:IIterator;
				var staticMethodParameter:Parameter;
				if(staticMethods == null)
				{
					trace("\tnone");
				}
				else
				{
					while (staticMethods.hasNext())
					{
						staticMethod = staticMethods.next();
						trace("\tStaticMethod");
						trace("\t\tName:" + staticMethod.name);
						trace("\t\tDeclaredByType:" + staticMethod.declaredByType);
						trace("\t\tReturnType:" + staticMethod.returnType);
						trace("\t\tReturnDefinition:" + staticMethod.returnDefinition);
						
						staticMethodParameters = staticMethod.parametersIterator();
						trace("\t\tParameters");
						if (staticMethodParameters == null)
						{
							trace("\t\t\tnone");
						}
						else
						{
							while (staticMethodParameters.hasNext())
							{
								staticMethodParameter = staticMethodParameters.next();
								trace("\t\tParameter");
								trace("\t\t\tIndex:" + staticMethodParameter.index);
								trace("\t\t\tType:" + staticMethodParameter.type);
								trace("\t\t\tDefinition:" + staticMethodParameter.definition);
								trace("\t\t\tOptional:" + staticMethodParameter.optional);
							}
						}
					}
				}
			}
			
			if (content == 0 || content & STATIC_VARIABLES)
			{
				trace("StaticVariables");
				var staticVariables:IIterator = refObj.staticVariablesIterator();
				var staticVariable:Variable;
				if (staticVariables == null)
				{
					trace("\tnone");
				}
				else
				{
					while (staticVariables.hasNext())
					{
						staticVariable = staticVariables.next();
						trace("\tStaticVariable");
						trace("\t\tName:" + staticVariable.name);
						trace("\t\tType:" + staticVariable.type);
						trace("\t\tDefinition:" + staticVariable.definition);
					}
				}
			}
			
			if (content == 0 || content & CONSTANTS)
			{
				trace("Constants");
				var constants:IIterator = refObj.constantsIterator();
				var constant:Constant;
				if (constants != null)
				{
					while (constants.hasNext())
					{
						constant = constants.next();
						trace("\tConstant");
						trace("\t\tName:" + constant.name);
						trace("\t\tType:" + constant.type);
						trace("\t\tDefinition:" + constant.definition);
					}
				}
				else
				{
					trace("\tnone");
				}
			}
			
			if (content == 0 || content & ACCESSORS)
			{
				trace("Accessors");
				var accessors:IIterator = refObj.accessorsIterator();
				var accessor:Accessor;
				if(accessors == null)
				{
					trace("\tnone");
				}
				else
				{
					while (accessors.hasNext())
					{
						accessor = accessors.next();
						trace("\tAccessor");
						trace("\t\tName:" + accessor.name);
						trace("\t\tAccess:" + accessor.access);
						trace("\t\tType:" + accessor.type);
						trace("\t\tDefinition:" + accessor.definition);
						trace("\t\tDeclaredByType:" + accessor.declaredByType);
						trace("\t\tDeclaredByDefinition:" + accessor.declaredByDefinition);
					}
				}
			}
			
			if (content == 0 || content & METHODS)
			{
				trace("Methods");
				var methods:IIterator = refObj.methodsIterator();
				var method:Method;
				var methodParameters:IIterator;
				var methodParameter:Parameter;
				if(methods == null)
				{
					trace("\tnone");
				}
				else
				{
					while (methods.hasNext())
					{
						method = methods.next();
						trace("\tMethod");
						trace("\t\tName:" + method.name);
						trace("\t\tDeclaredByType:" + method.declaredByType);
						trace("\t\tReturnType:" + method.returnType);
						trace("\t\tReturnDefinition:" + method.returnDefinition);
						
						methodParameters = method.parametersIterator();
						trace("\t\tParameters");
						if (methodParameters == null)
						{
							trace("\t\t\tnone");
						}
						else
						{
							while (methodParameters.hasNext())
							{
								methodParameter = methodParameters.next();
								trace("\t\tParameter");
								trace("\t\t\tIndex:" + methodParameter.index);
								trace("\t\t\tType:" + methodParameter.type);
								trace("\t\t\tDefinition:" + methodParameter.definition);
								trace("\t\t\tOptional:" + methodParameter.optional);
							}
						}
					}
				}
			}
			
			if (content == 0 || content & VARIABLES)
			{
				trace("Variables");
				var variables:IIterator = refObj.variablesIterator();
				var variable:Variable;
				if (variables == null)
				{
					trace("\tnone");
				}
				else
				{
					while (variables.hasNext())
					{
						variable = variables.next();
						trace("\tVariable");
						trace("\t\tName:" + variable.name);
						trace("\t\tType:" + variable.type);
						trace("\t\tDefinition:" + variable.definition);
					}
				}
			}
			
			refObj.destroy();
			trace("----------------------------------------------------------------------------------------");
		}
	}

}