//
//  UISlider.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 9/11/21.
//

import UIKit

class CenteredThumbSlider : UISlider {
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect{
        let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let thumbOffsetToApplyOnEachSide:CGFloat = unadjustedThumbrect.size.width / 2.0
        let minOffsetToAdd = -thumbOffsetToApplyOnEachSide + 3
        let maxOffsetToAdd = thumbOffsetToApplyOnEachSide - 3
        let offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * CGFloat(value / (self.maximumValue - self.minimumValue))
        var origin = unadjustedThumbrect.origin
        origin.x += offsetForValue
        return CGRect(origin: origin, size: unadjustedThumbrect.size)
    }
}
