/****************************************************************************
Copyright (c) 2010 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
#import "CCImage.h"
#import "CCFileUtils.h"
#import "CCCommon.h"
#import <string>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include<math.h>

#include "X6FontCache.h"


typedef struct
{
    unsigned int height;
    unsigned int width;
    int          bitsPerComponent;
    bool         hasAlpha;
    bool         isPremultipliedAlpha;
    bool         hasShadow;
    CGSize       shadowOffset;
    float        shadowBlur;
    float        shadowOpacity;
    bool         hasStroke;
    float        strokeColorR;
    float        strokeColorG;
    float        strokeColorB;
    float        strokeSize;
    float        tintColorR;
    float        tintColorG;
    float        tintColorB;
    
    unsigned char*  data;
    
} tImageInfo;

static bool _initWithImage(CGImageRef cgImage, tImageInfo *pImageinfo)
{
    if(cgImage == NULL) 
    {
        return false;
    }
    
    // get image info
    
    pImageinfo->width = CGImageGetWidth(cgImage);
    pImageinfo->height = CGImageGetHeight(cgImage);
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(cgImage);
    pImageinfo->hasAlpha = (info == kCGImageAlphaPremultipliedLast) 
                            || (info == kCGImageAlphaPremultipliedFirst) 
                            || (info == kCGImageAlphaLast) 
                            || (info == kCGImageAlphaFirst);
    
    // If OS version < 5.x, add condition to support jpg
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(systemVersion < 5.0f)
    {
        pImageinfo->hasAlpha = (pImageinfo->hasAlpha || (info == kCGImageAlphaNoneSkipLast));
    }
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    if (colorSpace)
    {
        if (pImageinfo->hasAlpha)
        {
            info = kCGImageAlphaPremultipliedLast;
            pImageinfo->isPremultipliedAlpha = true;
        }
        else 
        {
            info = kCGImageAlphaNoneSkipLast;
            pImageinfo->isPremultipliedAlpha = false;
        }
    }
    else
    {
        return false;
    }
    
    // change to RGBA8888
    pImageinfo->hasAlpha = true;
    pImageinfo->bitsPerComponent = 8;
    pImageinfo->data = new unsigned char[pImageinfo->width * pImageinfo->height * 4];
    colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pImageinfo->data, 
                                                 pImageinfo->width, 
                                                 pImageinfo->height,
                                                 8, 
                                                 4 * pImageinfo->width, 
                                                 colorSpace, 
                                                 info | kCGBitmapByteOrder32Big);
    
    CGContextClearRect(context, CGRectMake(0, 0, pImageinfo->width, pImageinfo->height));
    //CGContextTranslateCTM(context, 0, 0);
    CGContextDrawImage(context, CGRectMake(0, 0, pImageinfo->width, pImageinfo->height), cgImage);
    
    CGContextRelease(context);
    CFRelease(colorSpace);
  
    return true;
}

static bool _initWithFile(const char* path, tImageInfo *pImageinfo)
{
    CGImageRef                CGImage;    
    UIImage                    *jpg;
    UIImage                    *png;
    bool            ret;
    
    // convert jpg to png before loading the texture
    
    NSString *fullPath = [NSString stringWithUTF8String:path];
    jpg = [[UIImage alloc] initWithContentsOfFile: fullPath];
    png = [[UIImage alloc] initWithData:UIImagePNGRepresentation(jpg)];
    CGImage = png.CGImage;    
    
    ret = _initWithImage(CGImage, pImageinfo);
    
    [png release];
    [jpg release];
    
    return ret;
}


static bool _initWithData(void * pBuffer, int length, tImageInfo *pImageinfo)
{
    bool ret = false;
    
    if (pBuffer) 
    {
        CGImageRef CGImage;
        NSData *data;
        
        data = [NSData dataWithBytes:pBuffer length:length];
        CGImage = [[UIImage imageWithData:data] CGImage];
        
        ret = _initWithImage(CGImage, pImageinfo);
    }
    
    return ret;
}

static CGSize _calculateStringSize(NSString *str, id font, CGSize *constrainSize)
{
    NSArray *listItems = [str componentsSeparatedByString: @"\n"];
    CGSize dim = CGSizeZero;
    CGSize textRect = CGSizeZero;
    textRect.width = constrainSize->width > 0 ? constrainSize->width
                                              : 0x7fffffff;
    textRect.height = constrainSize->height > 0 ? constrainSize->height
                                              : 0x7fffffff;
    
    
    for (NSString *s in listItems)
    {
        CGSize tmp = [s sizeWithFont:font constrainedToSize:textRect];
        
        if (tmp.width > dim.width)
        {
           dim.width = tmp.width; 
        }
        
        dim.height += tmp.height;
    }
    
    return dim;
}

// refer CCImage::ETextAlign
#define ALIGN_TOP    1
#define ALIGN_CENTER 3
#define ALIGN_BOTTOM 2

static bool _initWithString(const char * pText, cocos2d::CCImage::ETextAlign eAlign, const char * pFontName, int nSize, tImageInfo* pInfo)
{
    bool bRet = false;
    do 
    {
        CC_BREAK_IF(! pText || ! pInfo);
        
        NSString * str          = [NSString stringWithUTF8String:pText];
        NSString * fntName      = [NSString stringWithUTF8String:pFontName];
        
        CGSize dim, constrainSize;
        
        constrainSize.width     = pInfo->width;
        constrainSize.height    = pInfo->height;
        
        // On iOS custom fonts must be listed beforehand in the App info.plist (in order to be usable) and referenced only the by the font family name itself when
        // calling [UIFont fontWithName]. Therefore even if the developer adds 'SomeFont.ttf' or 'fonts/SomeFont.ttf' to the App .plist, the font must
        // be referenced as 'SomeFont' when calling [UIFont fontWithName]. Hence we strip out the folder path components and the extension here in order to get just
        // the font family name itself. This stripping step is required especially for references to user fonts stored in CCB files; CCB files appear to store
        // the '.ttf' extensions when referring to custom fonts.
        fntName = [[fntName lastPathComponent] stringByDeletingPathExtension];
        
        // create the font   
        id font = [UIFont fontWithName:fntName size:nSize];
        
        if (font)
        {
            dim = _calculateStringSize(str, font, &constrainSize);
        }
        else
        {
            if (!font)
            {
                font = [UIFont systemFontOfSize:nSize];
            }
                
            if (font)
            {
                dim = _calculateStringSize(str, font, &constrainSize);
            }
        }

        CC_BREAK_IF(! font);
        
        // compute start point
        int startH = 0;
        if (constrainSize.height > dim.height)
        {
            // vertical alignment
            unsigned int vAlignment = (eAlign >> 4) & 0x0F;
            if (vAlignment == ALIGN_TOP)
            {
                startH = 0;
            }
            else if (vAlignment == ALIGN_CENTER)
            {
                startH = (constrainSize.height - dim.height) / 2;
            }
            else 
            {
                startH = constrainSize.height - dim.height;
            }
        }
        
        // adjust text rect
        if (constrainSize.width > 0 && constrainSize.width > dim.width)
        {
            dim.width = constrainSize.width;
        }
        if (constrainSize.height > 0 && constrainSize.height > dim.height)
        {
            dim.height = constrainSize.height;
        }
        
        dim.width = (int)(dim.width / 2) * 2 + 2;
        dim.height = (int)(dim.height / 2) * 2 + 2;

        // compute the padding needed by shadow and stroke
        float shadowStrokePaddingX = 0.0f;
        float shadowStrokePaddingY = 0.0f;
        
        if ( pInfo->hasStroke )
        {
            shadowStrokePaddingX = ceilf(pInfo->strokeSize);
            shadowStrokePaddingY = ceilf(pInfo->strokeSize);
        }
        
        if ( pInfo->hasShadow )
        {
            shadowStrokePaddingX = std::max(shadowStrokePaddingX, (float)abs(pInfo->shadowOffset.width));
            shadowStrokePaddingY = std::max(shadowStrokePaddingY, (float)abs(pInfo->shadowOffset.height));
        }
        
        // add the padding (this could be 0 if no shadow and no stroke)
        dim.width  += shadowStrokePaddingX;
        dim.height += shadowStrokePaddingY;
        
        unsigned char* data = new unsigned char[(int)(dim.width * dim.height * 4)];
        memset(data, 0, (int)(dim.width * dim.height * 4));
        
        // draw text
        CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
        CGContextRef context        = CGBitmapContextCreate(data,
                                                            dim.width,
                                                            dim.height,
                                                            8,
                                                            (int)(dim.width) * 4,
                                                            colorSpace,
                                                            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGColorSpaceRelease(colorSpace);
        
        if (!context)
        {
            delete[] data;
            break;
        }

        // text color
        CGContextSetRGBFillColor(context, pInfo->tintColorR, pInfo->tintColorG, pInfo->tintColorB, 1);
        // move Y rendering to the top of the image
        CGContextTranslateCTM(context, 0.0f, (dim.height - shadowStrokePaddingY) );
        CGContextScaleCTM(context, 1.0f, -1.0f); //NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
        
        // store the current context
        UIGraphicsPushContext(context);
        
        // measure text size with specified font and determine the rectangle to draw text in
        unsigned uHoriFlag = eAlign & 0x0f;
        UITextAlignment align = (UITextAlignment)((2 == uHoriFlag) ? UITextAlignmentRight
                                : (3 == uHoriFlag) ? UITextAlignmentCenter
                                : UITextAlignmentLeft);

        
        // take care of stroke if needed
        if ( pInfo->hasStroke )
        {
            CGContextSetTextDrawingMode(context, kCGTextFillStroke);
            CGContextSetRGBStrokeColor(context, pInfo->strokeColorR, pInfo->strokeColorG, pInfo->strokeColorB, 1);
            CGContextSetLineWidth(context, pInfo->strokeSize);
        }
        
        // take care of shadow if needed
        if ( pInfo->hasShadow )
        {
            CGSize offset;
            offset.height = pInfo->shadowOffset.height;
            offset.width  = pInfo->shadowOffset.width;
            CGContextSetShadow(context, offset, pInfo->shadowBlur);
        }
        
        
        
        // normal fonts
        //if( [font isKindOfClass:[UIFont class] ] )
        //{
        //    [str drawInRect:CGRectMake(0, startH, dim.width, dim.height) withFont:font lineBreakMode:(UILineBreakMode)UILineBreakModeWordWrap alignment:align];
        //}
        //else // ZFont class
        //{
        //    [FontLabelStringDrawingHelper drawInRect:str rect:CGRectMake(0, startH, dim.width, dim.height) withZFont:font lineBreakMode:(UILineBreakMode)UILineBreakModeWordWrap 
        ////alignment:align];
        //}
    
        
        
        // compute the rect used for rendering the text
        // based on wether shadows or stroke are enabled
        
        float textOriginX  = 0.0;
        float textOrigingY = 0.0;
        
        float textWidth    = dim.width  - shadowStrokePaddingX;
        float textHeight   = dim.height - shadowStrokePaddingY;
        
        
        if ( pInfo->shadowOffset.width < 0 )
        {
            textOriginX = shadowStrokePaddingX;
        }
        else
        {
            textOriginX = 0.0;
        }
        
        if (pInfo->shadowOffset.height > 0)
        {
            textOrigingY = startH;
        }
        else
        {
            textOrigingY = startH - shadowStrokePaddingY;
        }
        
        
        // actually draw the text in the context
		// XXX: ios7 casting
        [str drawInRect:CGRectMake(textOriginX, textOrigingY, textWidth, textHeight) withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:(NSTextAlignment)align];
        
        // pop the context
        UIGraphicsPopContext();
        
        // release the context
        CGContextRelease(context);
               
        // output params
        pInfo->data                 = data;
        pInfo->hasAlpha             = true;
        pInfo->isPremultipliedAlpha = true;
        pInfo->bitsPerComponent     = 8;
        pInfo->width                = dim.width;
        pInfo->height               = dim.height;
        bRet                        = true;
        
    } while (0);

    return bRet;
}

NS_CC_BEGIN

CCImage::CCImage()
: m_nWidth(0)
, m_nHeight(0)
, m_nBitsPerComponent(0)
, m_pData(0)
, m_bHasAlpha(false)
, m_bPreMulti(false)
{
    
}

CCImage::~CCImage()
{
    CC_SAFE_DELETE_ARRAY(m_pData);
}

bool CCImage::initWithImageFile(const char * strPath, EImageFormat eImgFmt/* = eFmtPng*/)
{
	bool bRet = false;
    unsigned long nSize = 0;
    unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(
				CCFileUtils::sharedFileUtils()->fullPathForFilename(strPath).c_str(),
				"rb",
				&nSize);
				
    if (pBuffer != NULL && nSize > 0)
    {
        bRet = initWithImageData(pBuffer, nSize, eImgFmt);
    }
    CC_SAFE_DELETE_ARRAY(pBuffer);
    return bRet;
}

bool CCImage::initWithImageFileThreadSafe(const char *fullpath, EImageFormat imageType)
{
    /*
     * CCFileUtils::fullPathFromRelativePath() is not thread-safe, it use autorelease().
     */
    bool bRet = false;
    unsigned long nSize = 0;
    unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(fullpath, "rb", &nSize);
    if (pBuffer != NULL && nSize > 0)
    {
        bRet = initWithImageData(pBuffer, nSize, imageType);
    }
    CC_SAFE_DELETE_ARRAY(pBuffer);
    return bRet;
}

bool CCImage::initWithImageData(void * pData, 
                                int nDataLen, 
                                EImageFormat eFmt,
                                int nWidth,
                                int nHeight,
                                int nBitsPerComponent)
{
    bool bRet = false;
    tImageInfo info = {0};
    
    info.hasShadow = false;
    info.hasStroke = false;
    
    do 
    {
        CC_BREAK_IF(! pData || nDataLen <= 0);
        if (eFmt == kFmtRawData)
        {
            bRet = _initWithRawData(pData, nDataLen, nWidth, nHeight, nBitsPerComponent, false);
        }
        else if (eFmt == kFmtWebp)
        {
            bRet = _initWithWebpData(pData, nDataLen);
        }
        else // init with png or jpg file data
        {
            bRet = _initWithData(pData, nDataLen, &info);
            if (bRet)
            {
                m_nHeight = (short)info.height;
                m_nWidth = (short)info.width;
                m_nBitsPerComponent = info.bitsPerComponent;
                m_bHasAlpha = info.hasAlpha;
                m_bPreMulti = info.isPremultipliedAlpha;
                m_pData = info.data;
            }
        }
    } while (0);
    
    return bRet;
}

bool CCImage::_initWithRawData(void *pData, int nDatalen, int nWidth, int nHeight, int nBitsPerComponent, bool bPreMulti)
{
    bool bRet = false;
    do 
    {
        CC_BREAK_IF(0 == nWidth || 0 == nHeight);

        m_nBitsPerComponent = nBitsPerComponent;
        m_nHeight   = (short)nHeight;
        m_nWidth    = (short)nWidth;
        m_bHasAlpha = true;

        // only RGBA8888 supported
        int nBytesPerComponent = 4;
        int nSize = nHeight * nWidth * nBytesPerComponent;
        m_pData = new unsigned char[nSize];
        CC_BREAK_IF(! m_pData);
        memcpy(m_pData, pData, nSize);

        bRet = true;
    } while (0);
    return bRet;
}

bool CCImage::_initWithJpgData(void *pData, int nDatalen)
{
    assert(0);
	return false;
}

bool CCImage::_initWithPngData(void *pData, int nDatalen)
{
    assert(0);
	return false;
}

bool CCImage::_saveImageToPNG(const char *pszFilePath, bool bIsToRGB)
{
    assert(0);
	return false;
}

bool CCImage::_saveImageToJPG(const char *pszFilePath)
{
    assert(0);
	return false;
}

bool CCImage::initWithWord(
                                         const char * pText,
                                         const char * pFontName ,
                                         int         nSize ,
                                         unsigned long color,
                                         bool shadow,
                                         float shadowOffsetX,
                                         float shadowOffsetY,
                                         float shadowOpacity,
                                         float shadowBlur,
                                         bool  stroke,
                                         float strokeR,
                                         float strokeG,
                                         float strokeB,
                                         float strokeSize,
                                         int         nWidth /*= 0*/,
                                         int         nHeight /*= 0*/,
                                         ETextAlign eAlignMask /*= kAlignLeft*/)
{
    
   
    
    tImageInfo info = {0};
    info.width                  = nWidth;
    info.height                 = nHeight;
    info.hasShadow              = shadow;
    info.shadowOffset.width     = shadowOffsetX;
    info.shadowOffset.height    = shadowOffsetY;
    info.shadowBlur             = shadowBlur;
    info.shadowOpacity          = shadowOpacity;
    info.hasStroke              =  stroke;
    info.strokeColorR           =  strokeR;
    info.strokeColorG           = strokeG;
    info.strokeColorB           = strokeB;
    info.strokeSize             = strokeSize;
    info.tintColorR             = ((color&0xff0000)>>16)/255.f;
    info.tintColorG             = ((color&0xff00)>>8)/255.f;
    info.tintColorB             = (color&0xff)/255.f;
    
    
    if (! _initWithString(pText, eAlignMask, pFontName, nSize, &info))
    {
        return false;
    }
    m_nHeight = (short)info.height;
    m_nWidth = (short)info.width;
    m_nBitsPerComponent = info.bitsPerComponent;
    m_bHasAlpha = info.hasAlpha;
    m_bPreMulti = info.isPremultipliedAlpha;
    m_pData = info.data;
    
    return true;
}


bool CCImage::saveToFile(const char *pszFilePath, bool bIsToRGB)
{
    bool saveToPNG = false;
    bool needToCopyPixels = false;
    std::string filePath(pszFilePath);
    if (std::string::npos != filePath.find(".png"))
    {
        saveToPNG = true;
    }
        
    int bitsPerComponent = 8;            
    int bitsPerPixel = m_bHasAlpha ? 32 : 24;
    if ((! saveToPNG) || bIsToRGB)
    {
        bitsPerPixel = 24;
    }            
    
    int bytesPerRow    = (bitsPerPixel/8) * m_nWidth;
    int myDataLength = bytesPerRow * m_nHeight;
    
    unsigned char *pixels    = m_pData;
    
    // The data has alpha channel, and want to save it with an RGB png file,
    // or want to save as jpg,  remove the alpha channel.
    if ((saveToPNG && m_bHasAlpha && bIsToRGB)
       || (! saveToPNG))
    {
        pixels = new unsigned char[myDataLength];
        
        for (int i = 0; i < m_nHeight; ++i)
        {
            for (int j = 0; j < m_nWidth; ++j)
            {
                pixels[(i * m_nWidth + j) * 3] = m_pData[(i * m_nWidth + j) * 4];
                pixels[(i * m_nWidth + j) * 3 + 1] = m_pData[(i * m_nWidth + j) * 4 + 1];
                pixels[(i * m_nWidth + j) * 3 + 2] = m_pData[(i * m_nWidth + j) * 4 + 2];
            }
        }
        
        needToCopyPixels = true;
    }
        
    // make data provider with data.
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    if (saveToPNG && m_bHasAlpha && (! bIsToRGB))
    {
        bitmapInfo |= kCGImageAlphaPremultipliedLast;
    }
    CGDataProviderRef provider        = CGDataProviderCreateWithData(NULL, pixels, myDataLength, NULL);
    CGColorSpaceRef colorSpaceRef    = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref                    = CGImageCreate(m_nWidth, m_nHeight,
                                                        bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                        colorSpaceRef, bitmapInfo, provider,
                                                        NULL, false,
                                                        kCGRenderingIntentDefault);
        
    UIImage* image                    = [[UIImage alloc] initWithCGImage:iref];
        
    CGImageRelease(iref);    
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    NSData *data;
                
    if (saveToPNG)
    {
        data = UIImagePNGRepresentation(image);
    }
    else
    {
        data = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    [data writeToFile:[NSString stringWithUTF8String:pszFilePath] atomically:YES];
        
    [image release];
        
    if (needToCopyPixels)
    {
        delete [] pixels;
    }
    
    return true;
}

bool CCImage::initWithLines(
    vector<vector<CCImage*> > &lines,
    int             nWidth,
    int             nHeight,
    ETextAlign      eAlignMask,
    int rowSpace)
{
    // 没指定宽度
    if( nWidth<=0 )
    {
        m_nWidth = 0;

        int numLine = lines.size();
        for(int i=0; i<numLine; ++i)
        {
            nWidth = 0;
            vector<CCImage*>& line = lines[i];
            int numChar = line.size();
            for (int j=0; j<numChar; ++j)
            {
                nWidth += line[j]->getWidth();
            }

            if( nWidth>m_nWidth )
            {
                m_nWidth = nWidth;
            }
        }
    }
    else
    {
        m_nWidth = nWidth;
    }

    // 根据宽度，换行，计算高度
    m_nHeight = 0;
    vector<int> lineHeights;
    vector<int> lineWidths;
    int curHeight = 0;
    int curWidth = 0;
    CCImage *pImg;
    for(int i=0; i<lines.size(); ++i)
    {
        curHeight = 0;
        curWidth = 0;

        vector<CCImage*>* line = &lines[i];
        int numChar = line->size();
        for (int j=0; j<numChar; ++j)
        {
            pImg = (*line)[j];

            // 换行
            if( (curWidth+pImg->getWidth())>m_nWidth )
            {
                lines.insert(lines.begin()+i+1, vector<CCImage*>(line->begin()+j, line->end()));

                // lines.insert 可能会重新分配内存，导致line可能变成野指针
                // 下面把line重新赋值
                line = &lines[i];
                line->erase(line->begin()+j, line->end());
                break;
            }

            curWidth += pImg->getWidth();

            if( curHeight<pImg->getHeight() )
            {
                curHeight = pImg->getHeight();
            }
        }

        lineWidths.push_back(curWidth);
        lineHeights.push_back(curHeight);
        m_nHeight += curHeight+rowSpace;
    }

    // 设定高度比实际高度要小
    if( m_nHeight>nHeight )
    {
        nHeight = m_nHeight;
    }


    bool bRet = false;

    // alloc image data buffer
    do 
    {
        CC_BREAK_IF( m_nWidth<=0 && nHeight<=0 );

        m_pData = new unsigned char[m_nWidth * nHeight * 4];
        CC_BREAK_IF(! m_pData);
        memset(m_pData, 0, m_nWidth * nHeight * 4);

        bool hRight = (eAlignMask&0x0f)==2;
        bool hCenter = (eAlignMask&0x0f)==3;
        bool vCerter = ((eAlignMask&0xf0)>>4)==3;
        bool vBottom = ((eAlignMask&0xf0)>>4)==2;

        // Y偏移
        int curY = 0;
        if( vCerter )
        {
            curY = (nHeight-m_nHeight)/2;
        }
        else if( vBottom )
        {
            curY = nHeight-m_nHeight;
        }

        // X偏移
        int curX = 0;
        pImg = NULL;

        int imgHeight;
        int imgWidth;
        int lineHeight;
        int numLine = lines.size();
        for( int i=0; i<numLine; ++i )
        {
            curX = 0;
            if( hRight )
            {
                curX = m_nWidth-lineWidths[i];
            }
            else if( hCenter )
            {
                curX = (m_nWidth-lineWidths[i])/2;
            }

            lineHeight = lineHeights[i];

            vector<CCImage*>& line = lines[i];
            int numChar = line.size();
            for( int j=0; j<numChar; ++j )
            {
                pImg = line[j];

                imgHeight = pImg->getHeight();
                imgWidth = pImg->getWidth();

                unsigned char *pSrc = pImg->getData();
                unsigned char *pDst = m_pData+((curY+lineHeight-imgHeight)*m_nWidth+curX)*4;
                for (int k=0; k<imgHeight; ++k)
                {
                    memcpy(pDst, pSrc, imgWidth*4);
                    pDst += m_nWidth*4;
                    pSrc += imgWidth*4;
                }

                curX += imgWidth;
            }

            curY += lineHeight+rowSpace;
        }

        m_nHeight = nHeight;
        m_bHasAlpha = pImg?pImg->hasAlpha():true;
        m_bPreMulti = pImg?pImg->isPremultipliedAlpha():false;
        m_nBitsPerComponent = pImg?pImg->getBitsPerComponent():8;

        bRet = true;
    } while (0);

    return bRet;
}

bool CCImage::initWithString(
    const char *    pText, 
    int             nWidth/* = 0*/, 
    int             nHeight/* = 0*/,
    ETextAlign      eAlignMask/* = kAlignCenter*/,
    const char *    pFontName/* = nil*/,
    int             nSize/* = 0*/,
    int rowSpace/* = 0*/,
    bool isRichText/* = false*/)
{
    if( !isRichText || !X6FontCache::hasFontMark(pText) )
    {
        return this->initWithWord(pText, pFontName, nSize, 
            0xffffff, false, 0.f, 0.f, 0.f, 0.f,
            false, 1.f, 1.f, 1.f, 1.f,
            nWidth, nHeight, eAlignMask);
    }

    bool bRet = false;

    do 
    {
        CC_BREAK_IF(! pText); 

        vector<vector<CCImage*> > lines;
        bRet = X6FontCache::generateTextLines(lines, pText, pFontName, nSize);
        CC_BREAK_IF(! bRet);     

        bRet = this->initWithLines(lines, nWidth, nHeight, eAlignMask, rowSpace);
        CC_BREAK_IF(! bRet); 

        // 检查字体缓存
        X6FontCache::clearOutdates();

        bRet = true;
    } while (0);

    return bRet;
}

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) || (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

bool CCImage::initWithStringShadowStroke(
    const char *    pText,
    int             nWidth/*      = 0*/,
    int             nHeight/*     = 0*/,
    ETextAlign      eAlignMask/*  = kAlignCenter*/,
    const char *    pFontName/*   = 0*/,
    int             nSize/*       = 0*/,
    float           textTintR/*   = 1*/,
    float           textTintG/*   = 1*/,
    float           textTintB/*   = 1*/,
    bool shadow/*                 = false*/,
    float shadowOffsetX/*         = 0.0*/,
    float shadowOffsetY/*         = 0.0*/,
    float shadowOpacity/*         = 0.0*/,
    float shadowBlur/*            = 0.0*/,
    bool  stroke/*                =  false*/,
    float strokeR/*               = 1*/,
    float strokeG/*               = 1*/,
    float strokeB/*               = 1*/,
    float strokeSize/*            = 1*/,
    int rowSpace/* = 0*/,
    bool isRichText/* = false*/)
{
    if( !isRichText || !X6FontCache::hasFontMark(pText) )
    {
        unsigned long color = (int(textTintR*0xff)<<16)|(int(textTintG*0xff)<<8)|int(textTintB*0xff);
        return this->initWithWord(pText, pFontName, nSize,
            color, shadow, shadowOffsetX, shadowOffsetY, shadowOpacity, shadowBlur,
            stroke, strokeR, strokeG, strokeB, strokeSize,
            nWidth, nHeight, eAlignMask);
    }

    bool bRet = false;

    do 
    {
        CC_BREAK_IF(! pText); 

        vector<vector<CCImage*> > lines;
        bRet = X6FontCache::generateTextLines(lines, pText, pFontName, nSize,
            shadow, shadowOffsetX, shadowOffsetY, shadowOpacity, shadowBlur,
            stroke, strokeR, strokeG, strokeB, strokeSize);
        CC_BREAK_IF(! bRet);     

        bRet = this->initWithLines(lines, nWidth, nHeight, eAlignMask, rowSpace);
        CC_BREAK_IF(! bRet); 

        // 检查字体缓存
        X6FontCache::clearOutdates();

        bRet = true;
    } while (0);

    return bRet;
}

#endif

NS_CC_END

