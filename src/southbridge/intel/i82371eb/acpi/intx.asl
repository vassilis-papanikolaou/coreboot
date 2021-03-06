/*
 * This file is part of the coreboot project.
 *
 * Copyright (C) 2010 Tobias Diedrich <ranma+coreboot@tdiedrich.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */
Name(IRQB, ResourceTemplate(){
	IRQ(Level,ActiveLow,Shared){}
})

Name(IRQP, ResourceTemplate(){
	IRQ(Level,ActiveLow,Shared){3, 4, 5, 6, 7, 10, 11, 12, 14, 15}
})

/* adapted from ma78gm/dsdt.asl */
#define PCI_INTX_DEV(intx, pinx, uid)			\
Device(intx) {						\
	Name(_HID, EISAID("PNP0C0F"))			\
	Name(_UID, uid)					\
							\
	Method(_STA, 0) {				\
		If (And(pinx, 0x80)) {			\
			Return(0x09)			\
		}					\
		Return(0x0B)				\
	}						\
							\
	Method(_DIS ,0) {				\
		Store(0x80, pinx)			\
	}						\
							\
	Method(_PRS ,0) {				\
		Return(IRQP)				\
	}						\
							\
	Method(_CRS ,0) {				\
		CreateWordField(IRQB, 1, IRQN)		\
		ShiftLeft(1, And(pinx, 0x0f), IRQN)	\
		Return(IRQB)				\
	}						\
							\
	Method(_SRS, 1) {				\
		CreateWordField(ARG0, 1, IRQM)		\
							\
		/* Use lowest available IRQ */		\
		FindSetRightBit(IRQM, Local0)		\
		if (Local0) {				\
			Decrement(Local0)		\
		}					\
		Store(Local0, pinx)			\
	}						\
}							\
